import SwiftUI



extension MDMermaidStyle {
    
    /// Mermaid 文本样式
    public struct TextStyle {
        /// 标签文本样式
        public var label: MDTextStyle
        /// 内容文本样式
        public var content: MDTextStyle
        
        /// 创建 Mermaid 文本样式
        public init(label: MDTextStyle, content: MDTextStyle) {
            self.label = label
            self.content = content
        }
    }
    
    /// Mermaid 视图样式
    public struct ViewStyle {
        /// 背景色
        public var backgroundColor: () -> Color
        /// 圆角
        public var cornerRadius: () -> CGFloat
        /// 内边距
        public var padding: () -> [Edge: CGFloat?]
        
        /// 创建 Mermaid 视图样式
        public init(
            backgroundColor: @escaping () -> Color,
            cornerRadius: @escaping () -> CGFloat,
            padding: @escaping () -> [Edge: CGFloat?]
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.padding = padding
        }
    }
}

/// Mermaid 图样式配置
public struct MDMermaidStyle: MDContentStyle {
    /// 输入文本
    public typealias Value = String
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var text: TextStyle
    /// 视图样式
    public var view: ViewStyle

    /// 创建 Mermaid 样式
    public init(
        body: bodyBuilder? = nil,
        text: TextStyle,
        view: ViewStyle
    ) {
        self.body = body
        self.text = text
        self.view = view
    }
}
