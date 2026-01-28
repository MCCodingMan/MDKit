//
//  MDInlineTextStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

/// 行内文本样式集合
public struct MDInlineTextStyle {
    /// 行内代码样式
    public var code: MDInlineStyle
    /// 强调样式
    public var emphasis: MDInlineStyle
    /// 加粗样式
    public var strong: MDInlineStyle
    /// 删除线样式
    public var strikethrough: MDInlineStyle
    /// 链接样式
    public var link: MDInlineStyle

    /// 创建行内文本样式
    public init(
        code: MDInlineStyle,
        emphasis: MDInlineStyle,
        strong: MDInlineStyle,
        strikethrough: MDInlineStyle,
        link: MDInlineStyle
    ) {
        self.code = code
        self.emphasis = emphasis
        self.strong = strong
        self.strikethrough = strikethrough
        self.link = link
    }
}
