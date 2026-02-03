//
//  MDFootnoteContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 脚注内容上下文
public struct MDFootnoteContext: Hashable, Sendable {
    /// 脚注标识
    public let label: String
    /// 脚注内容
    public let content: String

    /// 创建脚注上下文
    public init(label: String, content: String) {
        self.label = label
        self.content = content
    }
}
