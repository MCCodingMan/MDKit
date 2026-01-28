//
//  MDTextStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 文本样式配置
public struct MDTextStyle {
    /// 字体
    public var font: () -> Font
    /// 文字颜色
    public var color: () -> Color
    /// 行间距
    public var lineSpacing: (() -> CGFloat)? = nil

    /// 创建文本样式
    public init(font: @escaping () -> Font, color: @escaping () -> Color, lineSpacing: (() -> CGFloat)? = nil) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
}
