import SwiftUI

public struct MDFootnoteContext {
    public let label: String
    public let content: String

    public init(label: String, content: String) {
        self.label = label
        self.content = content
    }
}

extension MDFootnoteStyle {
    
    public struct TextStyle {
        public var label: MDTextStyle
        public var content: MDTextStyle
        
        public init(label: MDTextStyle, content: MDTextStyle) {
            self.label = label
            self.content = content
        }
    }
    
    public struct ViewStyle {
        public var spacing: () -> CGFloat
        
        public init(spacing: @escaping () -> CGFloat) {
            self.spacing = spacing
        }
    }
}

public struct MDFootnoteStyle: MDContentStyle {
    public typealias Value = MDFootnoteContext
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var textStyle: TextStyle
    public var viewStyle: ViewStyle

    public init(
        body: bodyBuilder? = nil,
        textStyle: TextStyle,
        viewStyle: ViewStyle
    ) {
        self.body = body
        self.textStyle = textStyle
        self.viewStyle = viewStyle
    }
}
