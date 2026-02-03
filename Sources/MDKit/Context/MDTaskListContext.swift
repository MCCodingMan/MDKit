//
//  MDTaskListContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 任务列表上下文
public struct MDTaskListContext: Hashable, Sendable {
    /// 任务项集合
    public let items: [MDTaskItem]

    /// 创建任务列表上下文
    public init(items: [MDTaskItem]) {
        self.items = items
    }
}
