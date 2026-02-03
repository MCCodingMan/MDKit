//
//  MDTextStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 文本样式配置
public struct MDTextStyle: Sendable {
    /// 字体
    public var font: @Sendable () -> Font
    /// 文字颜色
    public var color: @Sendable () -> Color
    /// 行间距
    public var lineSpacing: (@Sendable () -> CGFloat)? = nil
    /// 多行文本对齐方式
    public var multilineTextAlignment: (@Sendable () -> TextAlignment)? = nil

    /// 创建文本样式
    public init(font: @escaping @Sendable () -> Font, color: @escaping @Sendable () -> Color, lineSpacing: (@Sendable () -> CGFloat)? = nil, multilineTextAlignment: ( @Sendable() -> TextAlignment)? = nil) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
        self.multilineTextAlignment = multilineTextAlignment
    }
}
