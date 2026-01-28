//
//  MDInlineCodeStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 行内样式配置
public struct MDInlineStyle {
    /// 文本颜色
    public var textColor: () -> Color
    /// 背景颜色
    public var backgroundColor: () -> Color

    /// 创建行内样式
    public init(
        textColor: @escaping () -> Color,
        backgroundColor: @escaping () -> Color
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
