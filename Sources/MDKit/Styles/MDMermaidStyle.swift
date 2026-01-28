import SwiftUI



extension MDMermaidStyle {
    
    public struct TextStyle {
        public var label: MDTextStyle
        public var content: MDTextStyle
        
        public init(label: MDTextStyle, content: MDTextStyle) {
            self.label = label
            self.content = content
        }
    }
    
    public struct ViewStyle {
        public var backgroundColor: () -> Color
        public var cornerRadius: () -> CGFloat
        public var padding: () -> [Edge: CGFloat?]
        
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

public struct MDMermaidStyle: MDContentStyle {
    public typealias Value = String
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var text: TextStyle
    public var view: ViewStyle

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
