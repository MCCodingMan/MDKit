//
//  MDQuoteContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 引用块内容上下文
public struct MDQuoteContext: Hashable, Sendable {
    /// 引用文本行
    public let lines: [String]
    
    /// 创建引用上下文
    public init(lines: [String]) {
        self.lines = lines
    }
}
