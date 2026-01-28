import SwiftUI

public struct MDCodeBlockContext {
    public let code: String
    public let language: String?

    public init(code: String, language: String?) {
        self.code = code
        self.language = language
    }
}

extension MDCodeStyle {
    
    public struct LanguageViewStyle {
        public var view: ((String) -> AnyView)?
        public var text: MDTextStyle
        public var padding: () -> [Edge: CGFloat?]
        public var background: () -> Color
        
        public init(view: ((String) -> AnyView)? = nil, text: MDTextStyle, padding: @escaping () -> [Edge : CGFloat?], background: @escaping () -> Color) {
            self.view = view
            self.text = text
            self.padding = padding
            self.background = background
        }
    }
    
    
    public struct ContentViewStyle {
        public var view: ((String, String?) -> AnyView)?
        public var highlightCode: ((String, String?) -> NSAttributedString)? = nil
        public var codeSingleHeight: () -> CGFloat
        public var padding: () -> [Edge: CGFloat?]
        public var text: MDTextStyle
        public var background: () -> Color
        
        public init(view: ((String, String?) -> AnyView)? = nil, highlightCode: ((String, String?) -> NSAttributedString)? = nil, codeSingleHeight: @escaping () -> CGFloat, padding: @escaping () -> [Edge : CGFloat?], text: MDTextStyle, background: @escaping () -> Color) {
            self.view = view
            self.highlightCode = highlightCode
            self.codeSingleHeight = codeSingleHeight
            self.padding = padding
            self.text = text
            self.background = background
        }
    }
    
    public struct ViewStyle {
        public var languageView: LanguageViewStyle
        public var contentView: ContentViewStyle
        
        public init(languageView: LanguageViewStyle, contentView: ContentViewStyle) {
            self.languageView = languageView
            self.contentView = contentView
        }
    }
    
    public struct ContainerStyle {
        public var backgroundColor: () -> Color
        public var cornerRadius: () -> CGFloat
        public var border: MDBorderStyle
        
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

public struct MDCodeStyle: MDContentStyle {
    public typealias Value = MDCodeBlockContext
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var view: ViewStyle
    public var container: ContainerStyle

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
