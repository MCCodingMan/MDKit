//
//  MDInlineTextStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

public struct MDInlineTextStyle {
    public var code: MDInlineStyle
    public var emphasis: MDInlineStyle
    public var strong: MDInlineStyle
    public var strikethrough: MDInlineStyle
    public var link: MDInlineStyle

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
