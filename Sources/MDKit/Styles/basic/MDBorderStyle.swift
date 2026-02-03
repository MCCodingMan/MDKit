//
//  MDBorderStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 边框样式配置
public struct MDBorderStyle: Sendable {
    /// 边框颜色
    public var color: @Sendable () -> Color
    /// 边框宽度
    public var width: @Sendable () -> CGFloat
    /// 边框圆角半径
    public var cornerRadius: @Sendable () -> CGFloat

    /// 创建边框样式
    public init(color: @escaping @Sendable () -> Color,
                width: @escaping @Sendable () -> CGFloat,
                cornerRadius: @escaping @Sendable () -> CGFloat) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }
}
