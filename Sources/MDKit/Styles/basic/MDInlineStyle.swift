//
//  MDInlineCodeStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

public struct MDInlineStyle {
    public var textColor: () -> Color
    public var backgroundColor: () -> Color

    public init(
        textColor: @escaping () -> Color,
        backgroundColor: @escaping () -> Color
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
