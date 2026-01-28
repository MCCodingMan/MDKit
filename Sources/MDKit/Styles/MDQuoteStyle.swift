//
//  MDQuoteStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI


public struct MDQuoteContext {
    public let lines: [String]
    
    public init(lines: [String]) {
        self.lines = lines
    }
}

public struct MDQuoteStyle: MDContentStyle {
    
    public struct ViewStyle {
        public var lineSpacing: () -> CGFloat
        public var padding: () -> [Edge: CGFloat?]
        public var backgroundColor: () -> Color
        public var cornerRadius: () -> CGFloat
        public var border: MDBorderStyle
        
        public init(lineSpacing: @escaping () -> CGFloat, padding: @escaping () -> [Edge: CGFloat?], backgroundColor: @escaping () -> Color, cornerRadius: @escaping () -> CGFloat, border: MDBorderStyle) {
            self.lineSpacing = lineSpacing
            self.padding = padding
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.border = border
        }
    }
    
    public struct LineStyle {
        public var color: () -> Color
        public var width: () -> CGFloat
        public var lineView: (() -> AnyView)?
        
        public init(
            color: @escaping () -> Color,
            width: @escaping () -> CGFloat,
            lineView: (() -> AnyView)? = nil
        ) {
            self.color = color
            self.width = width
            self.lineView = lineView
        }
    }
    
    public typealias Value = MDQuoteContext
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var view: ViewStyle
    public var line: LineStyle
    public var text: MDTextStyle

    public init(
        body: bodyBuilder? = nil,
        view: ViewStyle,
        line: LineStyle,
        text: MDTextStyle
    ) {
        self.body = body
        self.view = view
        self.line = line
        self.text = text
    }
}
