//
//  MDTableContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 表格内容上下文
public struct MDTableContext: Hashable, Sendable {
    /// 表头
    public let headers: [String]
    /// 行数据
    public let rows: [[String]]

    /// 创建表格上下文
    public init(headers: [String], rows: [[String]]) {
        self.headers = headers
        self.rows = rows
    }
}
