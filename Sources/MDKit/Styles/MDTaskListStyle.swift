import SwiftUI

public struct MDTaskListContext {
    public let items: [MDTaskItem]

    public init(items: [MDTaskItem]) {
        self.items = items
    }
}

public struct MDTaskListStyle: MDContentStyle {
    
    
    public struct MarkerStyle {
        public var markerView: ((MDListMarkerContext) -> AnyView)?
        public var checkedColor: () -> Color
        public var uncheckedColor: () -> Color
        
        public init(
            markerView: ((MDListMarkerContext) -> AnyView)? = nil,
            checkedColor: @escaping () -> Color,
            uncheckedColor: @escaping () -> Color
        ) {
            self.markerView = markerView
            self.checkedColor = checkedColor
            self.uncheckedColor = uncheckedColor
        }
    }
    
    public struct ViewStyle {
        public var itemSpacing: () -> CGFloat
        public var markerSpacing: () -> CGFloat
        public var indent: () -> CGFloat
        
        public init(
            itemSpacing: @escaping () -> CGFloat,
            markerSpacing: @escaping () -> CGFloat,
            indent: @escaping () -> CGFloat
        ) {
            self.itemSpacing = itemSpacing
            self.markerSpacing = markerSpacing
            self.indent = indent
        }
    }
    
    public typealias Value = MDTaskListContext
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var text: MDTextStyle
    public var marker: MarkerStyle
    public var view: ViewStyle

    public init(
        body: bodyBuilder? = nil,
        text: MDTextStyle,
        marker: MarkerStyle,
        view: ViewStyle
    ) {
        self.body = body
        self.text = text
        self.marker = marker
        self.view = view
    }
}
