//
//  MDListMarkerContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 列表标记上下文
public struct MDListMarkerContext: Sendable {
    /// 当前序号
    public let index: Int
    /// 任务项勾选状态
    public let checked: Bool?
    /// 嵌套层级路径
    public let depthPath: [Int]
    
    /// 创建标记上下文
    public init(index: Int, checked: Bool?, depthPath: [Int]) {
        self.index = index
        self.checked = checked
        self.depthPath = depthPath
    }
}


/// 列表内容上下文
public struct MDListContext: Hashable, Sendable {
    /// 列表项集合
    public let items: [MDListItem]
    
    /// 创建列表上下文
    public init(items: [MDListItem]) {
        self.items = items
    }
}
