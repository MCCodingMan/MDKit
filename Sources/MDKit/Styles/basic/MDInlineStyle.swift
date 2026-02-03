//
//  MDInlineCodeStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 行内样式配置
public struct MDInlineStyle: Sendable {
    /// 文本字重
    public var weight: @Sendable () -> Font.Weight?
    /// 文本颜色
    public var textColor: @Sendable () -> Color
    /// 背景颜色
    public var backgroundColor: @Sendable () -> Color

    /// 创建行内样式
    public init(
        weight: @escaping @Sendable () -> Font.Weight?,
        textColor: @escaping @Sendable () -> Color,
        backgroundColor: @escaping @Sendable () -> Color
    ) {
        self.weight = weight
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
