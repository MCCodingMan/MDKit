import SwiftUI

/// 代码块内容上下文
public struct MDCodeBlockContext {
    /// 代码文本
    public let code: String
    /// 语言标识
    public let language: String?

    /// 创建代码块上下文
    public init(code: String, language: String?) {
        self.code = code
        self.language = language
    }
}

extension MDCodeStyle {
    
    /// 代码语言标签视图样式
    public struct LanguageViewStyle {
        /// 自定义语言视图
        public var view: ((String) -> AnyView)?
        /// 语言文本样式
        public var text: MDTextStyle
        /// 内边距
        public var padding: () -> [Edge: CGFloat?]
        /// 背景色
        public var background: () -> Color
        
        /// 创建语言标签样式
        public init(view: ((String) -> AnyView)? = nil, text: MDTextStyle, padding: @escaping () -> [Edge : CGFloat?], background: @escaping () -> Color) {
            self.view = view
            self.text = text
            self.padding = padding
            self.background = background
        }
    }
    
    
    /// 代码内容视图样式
    public struct ContentViewStyle {
        /// 自定义代码内容视图
        public var view: ((String, String?) -> AnyView)?
        /// 语法高亮处理
        public var highlightCode: ((String, String?) -> NSAttributedString)? = nil
        /// 单行高度
        public var codeSingleHeight: () -> CGFloat
        /// 内边距
        public var padding: () -> [Edge: CGFloat?]
        /// 文本样式
        public var text: MDTextStyle
        /// 背景色
        public var background: () -> Color
        
        /// 创建内容视图样式
        public init(view: ((String, String?) -> AnyView)? = nil, highlightCode: ((String, String?) -> NSAttributedString)? = nil, codeSingleHeight: @escaping () -> CGFloat, padding: @escaping () -> [Edge : CGFloat?], text: MDTextStyle, background: @escaping () -> Color) {
            self.view = view
            self.highlightCode = highlightCode
            self.codeSingleHeight = codeSingleHeight
            self.padding = padding
            self.text = text
            self.background = background
        }
    }
    
    /// 代码块整体视图样式
    public struct ViewStyle {
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
    public struct ContainerStyle {
        /// 背景色
        public var backgroundColor: () -> Color
        /// 圆角
        public var cornerRadius: () -> CGFloat
        /// 边框样式
        public var border: MDBorderStyle
        
        /// 创建容器样式
        public init(
            backgroundColor: @escaping () -> Color,
            cornerRadius: @escaping () -> CGFloat,
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
