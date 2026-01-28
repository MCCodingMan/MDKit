import SwiftUI

/// 图片内容上下文
public struct MDImageContext {
    /// 替代文本
    public let alt: String
    /// 图片地址
    public let url: String
    /// 标题
    public let title: String?

    /// 创建图片上下文
    public init(alt: String, url: String, title: String?) {
        self.alt = alt
        self.url = url
        self.title = title
    }
}

extension MDImageStyle {
    
    /// 图片视图样式
    public struct ViewStyle {
        /// 加载视图
        public var loadingView: (() -> AnyView)?
        /// 失败视图
        public var failureView: (() -> AnyView)?
        
        /// 创建图片视图样式
        public init(
            loadingView: (() -> AnyView)? = nil,
            failureView: (() -> AnyView)? = nil
        ) {
            self.loadingView = loadingView
            self.failureView = failureView
        }
    }
    
    /// 图片布局样式
    public struct LayoutStyle {
        /// 圆角
        public var cornerRadius: () -> CGFloat
        /// 标题间距
        public var titleSpacing: () -> CGFloat
        /// 标题对齐
        public var titleAlignment: () -> Alignment
        /// 占位高度
        public var placeholderHeight: () -> CGFloat
        
        /// 创建图片布局样式
        public init(cornerRadius: @escaping () -> CGFloat, titleSpacing: @escaping () -> CGFloat, titleAlignment: @escaping () -> Alignment, placeholderHeight: @escaping () -> CGFloat) {
            self.cornerRadius = cornerRadius
            self.titleSpacing = titleSpacing
            self.titleAlignment = titleAlignment
            self.placeholderHeight = placeholderHeight
        }
    }
}

/// 图片样式配置
public struct MDImageStyle: MDContentStyle {
    /// 输入上下文类型
    public typealias Value = MDImageContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var text: MDTextStyle
    /// 视图样式
    public var view: ViewStyle
    /// 布局样式
    public var layout: LayoutStyle

    /// 创建图片样式
    public init(
        body: bodyBuilder? = nil,
        text: MDTextStyle,
        view: ViewStyle,
        layout: LayoutStyle
    ) {
        self.body = body
        self.text = text
        self.view = view
        self.layout = layout
    }
}
