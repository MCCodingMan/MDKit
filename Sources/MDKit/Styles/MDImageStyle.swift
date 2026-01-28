import SwiftUI

public struct MDImageContext {
    public let alt: String
    public let url: String
    public let title: String?

    public init(alt: String, url: String, title: String?) {
        self.alt = alt
        self.url = url
        self.title = title
    }
}

extension MDImageStyle {
    
    public struct ViewStyle {
        public var loadingView: (() -> AnyView)?
        public var failureView: (() -> AnyView)?
        
        public init(
            loadingView: (() -> AnyView)? = nil,
            failureView: (() -> AnyView)? = nil
        ) {
            self.loadingView = loadingView
            self.failureView = failureView
        }
    }
    
    public struct LayoutStyle {
        public var cornerRadius: () -> CGFloat
        public var titleSpacing: () -> CGFloat
        public var titleAlignment: () -> Alignment
        public var placeholderHeight: () -> CGFloat
        
        public init(cornerRadius: @escaping () -> CGFloat, titleSpacing: @escaping () -> CGFloat, titleAlignment: @escaping () -> Alignment, placeholderHeight: @escaping () -> CGFloat) {
            self.cornerRadius = cornerRadius
            self.titleSpacing = titleSpacing
            self.titleAlignment = titleAlignment
            self.placeholderHeight = placeholderHeight
        }
    }
}

public struct MDImageStyle: MDContentStyle {
    public typealias Value = MDImageContext
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var text: MDTextStyle
    public var view: ViewStyle
    public var layout: LayoutStyle

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
