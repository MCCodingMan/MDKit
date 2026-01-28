//
//  MDBorderStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 边框样式配置
public struct MDBorderStyle {
    /// 边框颜色
    public var color: () -> Color
    /// 边框宽度
    public var width: () -> CGFloat
    /// 边框圆角半径
    public var cornerRadius: () -> CGFloat

    /// 创建边框样式
    public init(color: @escaping () -> Color, width: @escaping () -> CGFloat, cornerRadius: @escaping () -> CGFloat) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }
}
