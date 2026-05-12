import SwiftUI
import Combine

// MARK: - 图片缓存管理器
final class MDImageCache: @unchecked Sendable {
    static let shared = MDImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // 设置缓存限制
        cache.countLimit = 100 // 最多缓存100张图片
        cache.totalCostLimit = 1024 * 1024 * 100 // 最多100MB
    }
    
    // 获取图片
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    // 保存图片
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    // 清除缓存
    func clearCache() {
        cache.removeAllObjects()
    }
}

struct MDCachedAsyncImage<Content: View, Placeholder: View, FailurView: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    let failur: () -> FailurView
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failur: @escaping () -> FailurView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        self.failur = failur
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                failur()
            }
        }
        .onFirstAppear {
            Task {
                await loadImage()
            }
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            image = nil
            isLoading = false
            return
        }
        
        let cacheKey = url.absoluteString
        
        if let cachedImage = MDImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        self.image = nil
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedImage = await Task.detached(priority: .userInitiated, operation: { () -> UIImage? in
                guard let rawImage = UIImage(data: data) else { return nil }
                return rawImage.decoded()
            }).value {
                self.image = decodedImage
                MDImageCache.shared.setImage(decodedImage, forKey: cacheKey)
            }
        } catch { }
    }
}
