//
//  MDInlineCodeStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 行内样式配置
public struct MDInlineStyle {
    /// 文本字重
    public var weight: () -> Font.Weight?
    /// 文本颜色
    public var textColor: () -> Color
    /// 背景颜色
    public var backgroundColor: () -> Color

    /// 创建行内样式
    public init(
        weight: @escaping () -> Font.Weight?,
        textColor: @escaping () -> Color,
        backgroundColor: @escaping () -> Color
    ) {
        self.weight = weight
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
