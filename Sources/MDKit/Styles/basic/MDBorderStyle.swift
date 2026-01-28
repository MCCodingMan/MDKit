//
//  MDBorderStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

public struct MDBorderStyle {
    public var color: () -> Color
    public var width: () -> CGFloat
    public var cornerRadius: () -> CGFloat

    public init(color: @escaping () -> Color, width: @escaping () -> CGFloat, cornerRadius: @escaping () -> CGFloat) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }
}
