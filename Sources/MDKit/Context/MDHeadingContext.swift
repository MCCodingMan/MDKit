//
//  MDHeadingContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 标题内容上下文
public struct MDHeadingContext: Hashable, Sendable {
    /// 标题级别
    public let level: Int
    /// 标题文本
    public let text: String

    /// 创建标题上下文
    public init(level: Int, text: String) {
        self.level = level
        self.text = text
    }
}
