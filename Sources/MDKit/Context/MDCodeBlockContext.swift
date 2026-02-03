//
//  MDCodeBlockContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 代码块内容上下文
public struct MDCodeBlockContext: Hashable, Sendable {
    /// 代码文本
    public let code: String
    /// 语言标识
    public let language: String?

    /// 创建代码块上下文
    public init(code: String, language: String?) {
        self.code = code
        self.language = language
    }
}
