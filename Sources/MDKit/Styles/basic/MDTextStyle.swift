//
//  MDTextStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

public struct MDTextStyle {
    public var font: () -> Font
    public var color: () -> Color
    public var lineSpacing: (() -> CGFloat)? = nil

    public init(font: @escaping () -> Font, color: @escaping () -> Color, lineSpacing: (() -> CGFloat)? = nil) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
}
