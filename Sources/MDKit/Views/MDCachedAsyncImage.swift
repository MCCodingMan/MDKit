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

// MARK: - 图片解码扩展
private extension UIImage {
    /// 在后台强制解码图片，避免在主线程渲染时造成卡顿
    func decoded() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        
        // 创建颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 创建位图上下文
        // 使用预乘 alpha 以获得更好的性能
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        // 绘制图片到上下文中（这一步会触发解码）
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // 从上下文获取解码后的图片
        guard let decodedCGImage = context.makeImage() else { return nil }
        
        return UIImage(cgImage: decodedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

// MARK: - 自定义 AsyncImage 视图
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
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url = url else {
            image = nil
            isLoading = false
            return
        }
        
        let cacheKey = url.absoluteString
        
        // 1. 检查缓存
        if let cachedImage = MDImageCache.shared.getImage(forKey: cacheKey) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        // 2. 准备加载：清除旧图片并显示 loading
        self.image = nil
        self.isLoading = true
        
        // 确保退出时重置 loading 状态
        defer { self.isLoading = false }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 3. 后台解码
            if let decodedImage = await Task.detached(priority: .userInitiated, operation: { () -> UIImage? in
                guard let rawImage = UIImage(data: data) else { return nil }
                return rawImage.decoded()
            }).value {
                // 4. 更新 UI 和缓存
                self.image = decodedImage
                MDImageCache.shared.setImage(decodedImage, forKey: cacheKey)
            }
        } catch {
            print("Image load failed: \(error)")
        }
    }
}
