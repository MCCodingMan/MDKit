//
//  MDListStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI


public struct MDListMarkerContext {
    public let index: Int
    public let checked: Bool?
    public let depthPath: [Int]
    
    public init(index: Int, checked: Bool?, depthPath: [Int]) {
        self.index = index
        self.checked = checked
        self.depthPath = depthPath
    }
}


public struct MDListContext {
    public let items: [MDListItem]
    
    public init(items: [MDListItem]) {
        self.items = items
    }
}

extension MDListStyle {
    
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
    
    public struct MarkerStyle {
        public var markerView: ((MDListMarkerContext) -> AnyView)?
        public var markerFont: () -> Font
        public var markerColor: () -> Color
        
        public init(
            markerView: ((MDListMarkerContext) -> AnyView)? = nil,
            markerFont: @escaping () -> Font,
            markerColor: @escaping () -> Color
        ) {
            self.markerView = markerView
            self.markerFont = markerFont
            self.markerColor = markerColor
        }
    }
    
}

public struct MDListStyle: MDContentStyle {
    public typealias Value = MDListContext
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
