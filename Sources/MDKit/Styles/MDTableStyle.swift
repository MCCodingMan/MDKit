import SwiftUI

public struct MDTableContext {
    public let headers: [String]
    public let rows: [[String]]

    public init(headers: [String], rows: [[String]]) {
        self.headers = headers
        self.rows = rows
    }
}

public struct MDTableStyle: MDContentStyle {
    public typealias Value = MDTableContext
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

extension MDTableStyle {
    
    public struct TextStyle {
        public var headerText: MDTextStyle
        public var bodyText: MDTextStyle
        
        public init(headerText: MDTextStyle, bodyText: MDTextStyle) {
            self.headerText = headerText
            self.bodyText = bodyText
        }
    }
    
    public struct LineStyle {
        public var lineWidth: () -> CGFloat
        public var lineColor: () -> Color
        
        public init(lineWidth: @escaping () -> CGFloat, lineColor: @escaping () -> Color) {
            self.lineWidth = lineWidth
            self.lineColor = lineColor
        }
    }
    
    
    public struct ViewStyle {
        public var headerBackgroundColor: () -> Color
        public var bodyBackgroundColor: () -> Color
        public var cornerRadius: () -> CGFloat
        public var border: MDBorderStyle
        public var cellPadding: () -> [Edge: CGFloat?]
        public var cellMaxWidth: () -> CGFloat?
        public var headerLine: LineStyle
        public var bodyLine: LineStyle
        
        public init(headerBackgroundColor: @escaping () -> Color, bodyBackgroundColor: @escaping () -> Color, cornerRadius: @escaping () -> CGFloat, border: MDBorderStyle, cellPadding: @escaping () -> [Edge : CGFloat?], cellMaxWidth: @escaping () -> CGFloat?, headerLine: LineStyle, bodyLine: LineStyle) {
            self.headerBackgroundColor = headerBackgroundColor
            self.bodyBackgroundColor = bodyBackgroundColor
            self.cornerRadius = cornerRadius
            self.border = border
            self.cellPadding = cellPadding
            self.cellMaxWidth = cellMaxWidth
            self.headerLine = headerLine
            self.bodyLine = bodyLine
        }
    }
}
