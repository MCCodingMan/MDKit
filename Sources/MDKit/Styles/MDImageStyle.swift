import SwiftUI

extension MDImageStyle {
    
    /// 图片视图样式
    public struct ViewStyle : Sendable{
        /// 加载视图
        public var loadingView: (@Sendable () -> AnyView)?
        /// 失败视图
        public var failureView: (@Sendable () -> AnyView)?
        
        /// 创建图片视图样式
        public init(
            loadingView: (@Sendable () -> AnyView)? = nil,
            failureView: (@Sendable () -> AnyView)? = nil
        ) {
            self.loadingView = loadingView
            self.failureView = failureView
        }
    }
    
    /// 图片布局样式
    public struct LayoutStyle : Sendable{
        /// 圆角
        public var cornerRadius: @Sendable () -> CGFloat
        /// 标题间距
        public var titleSpacing: @Sendable () -> CGFloat
        /// 标题对齐
        public var titleAlignment: @Sendable () -> Alignment
        /// 占位高度
        public var height: @Sendable () -> CGFloat?
        
        /// 创建图片布局样式
        public init(cornerRadius: @escaping @Sendable () -> CGFloat, titleSpacing: @escaping @Sendable () -> CGFloat, titleAlignment: @escaping @Sendable () -> Alignment, height: @escaping @Sendable () -> CGFloat?) {
            self.cornerRadius = cornerRadius
            self.titleSpacing = titleSpacing
            self.titleAlignment = titleAlignment
            self.height = height
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
