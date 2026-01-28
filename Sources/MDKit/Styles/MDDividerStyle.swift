import SwiftUI

extension MDDividerStyle {
    
    public struct LineStyle {
        public var color: () -> Color
        public var height: () -> CGFloat
        public var padding: () -> [Edge: CGFloat?]
        
        public init(color: @escaping () -> Color, height: @escaping () -> CGFloat, padding: @escaping () -> [Edge: CGFloat?]) {
            self.color = color
            self.height = height
            self.padding = padding
        }
    }
}

public struct MDDividerStyle: MDContentStyle {
    public typealias Value = Void
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var line: LineStyle

    public init(
        body: bodyBuilder? = nil,
        line: LineStyle,
    ) {
        self.body = body
        self.line = line
    }
}
