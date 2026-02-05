import SwiftUI

extension MDCodeStyle {
    
    /// 代码语言标签视图样式
    public struct LanguageViewStyle: Sendable {
        /// 自定义语言视图
        public var view: (@Sendable (String) -> AnyView)?
        /// 语言文本样式
        public var text: MDTextStyle
        /// 内边距
        public var padding: @Sendable () -> [Edge: CGFloat?]
        /// 背景色
        public var background: @Sendable () -> Color
        
        /// 创建语言标签样式
        public init(view: (@Sendable (String) -> AnyView)? = nil, text: MDTextStyle, padding: @escaping @Sendable () -> [Edge : CGFloat?], background: @escaping @Sendable () -> Color) {
            self.view = view
            self.text = text
            self.padding = padding
            self.background = background
        }
    }
    
    
    /// 代码内容视图样式
    public struct ContentViewStyle: Sendable {
        /// 自定义代码内容视图
        public var view: (@Sendable (String, String?) -> AnyView)?
        /// 语法高亮处理
        public var highlightCode: (@Sendable (String, String?) async -> NSAttributedString)? = nil
        /// 单行高度
        public var codeSingleHeight: @Sendable () -> CGFloat?
        /// 内边距
        public var padding: @Sendable () -> [Edge: CGFloat?]
        /// 文本样式
        public var text: MDTextStyle
        /// 背景色
        public var background: @Sendable () -> Color
        
        /// 创建内容视图样式
        public init(view: (@Sendable (String, String?) -> AnyView)? = nil, highlightCode: (@Sendable (String, String?) async -> NSAttributedString)? = nil, codeSingleHeight: @escaping @Sendable () -> CGFloat?, padding: @escaping @Sendable () -> [Edge : CGFloat?], text: MDTextStyle, background: @escaping @Sendable () -> Color) {
            self.view = view
            self.highlightCode = highlightCode
            self.codeSingleHeight = codeSingleHeight
            self.padding = padding
            self.text = text
            self.background = background
        }
    }
    
    /// 代码块整体视图样式
    public struct ViewStyle: Sendable {
        /// 语言标签样式
        public var languageView: LanguageViewStyle
        /// 内容视图样式
        public var contentView: ContentViewStyle
        
        /// 创建视图样式
        public init(languageView: LanguageViewStyle, contentView: ContentViewStyle) {
            self.languageView = languageView
            self.contentView = contentView
        }
    }
    
    /// 代码块容器样式
    public struct ContainerStyle: Sendable {
        /// 背景色
        public var backgroundColor: @Sendable () -> Color
        /// 圆角
        public var cornerRadius: @Sendable () -> CGFloat
        /// 边框样式
        public var border: MDBorderStyle
        
        /// 创建容器样式
        public init(
            backgroundColor: @escaping @Sendable () -> Color,
            cornerRadius: @escaping @Sendable () -> CGFloat,
            border: MDBorderStyle,
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.border = border
        }
    }
}

/// 代码块样式配置
public struct MDCodeStyle: MDContentStyle {
    /// 输入上下文类型
    public typealias Value = MDCodeBlockContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 视图样式
    public var view: ViewStyle
    /// 容器样式
    public var container: ContainerStyle

    /// 创建代码块样式
    public init(
        body: bodyBuilder? = nil,
        view: ViewStyle,
        container: ContainerStyle
    ) {
        self.body = body
        self.view = view
        self.container = container
    }
}
