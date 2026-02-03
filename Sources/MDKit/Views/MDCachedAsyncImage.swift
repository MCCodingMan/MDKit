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

// MARK: - 图片加载器
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private var cancellable: AnyCancellable?
    private let cache = MDImageCache.shared
    
    func loadImage(from url: URL) {
        let cacheKey = url.absoluteString
        
        // 检查缓存
        if let cachedImage = cache.getImage(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // 开始加载
        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] image in
                    guard let self = self, let image = image else { return }
                    self.image = image
                    // 保存到缓存
                    self.cache.setImage(image, forKey: cacheKey)
                }
            )
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancel()
    }
}

// MARK: - 自定义 AsyncImage 视图
struct MDCachedAsyncImage<Content: View, Placeholder: View, FailurView: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    let failur: () -> FailurView
    
    @StateObject private var loader = ImageLoader()
    
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
            if let image = loader.image {
                content(Image(uiImage: image))
            } else if loader.isLoading {
                placeholder()
            } else {
                failur()
            }
        }
        .onAppear {
            if let url = url {
                loader.loadImage(from: url)
            }
        }
        .onChange(of: url) { newURL in
            if let newURL = newURL {
                loader.loadImage(from: newURL)
            }
        }
    }
}
