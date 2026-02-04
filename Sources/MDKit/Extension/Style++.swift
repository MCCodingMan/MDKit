//
//  Style++.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/4.
//

import SwiftUI

/// 局部样式修改器
private struct MDPartStyleModifier<Value>: ViewModifier {
    @Environment(\.mdStyle) private var style
    let target: MDStyleTarget<Value>
    let update: (inout Value) -> Void
    
    /// 应用局部样式
    func body(content: Content) -> some View {
        var updated = style
        update(&updated[keyPath: target.keyPath])
        return content.environment(\.mdStyle, updated)
    }
}


/// 全局样式修改器
private struct MDStyleModifier: ViewModifier {
    @Environment(\.mdStyle) private var style
    let update: (inout MDStyle) -> Void
    
    /// 应用全局样式
    func body(content: Content) -> some View {
        var updated = style
        update(&updated)
        return content.environment(\.mdStyle, updated)
    }
}

/// View 样式扩展
public extension View {
    /// 设置整体 Markdown 样式
    func mdStyle(_ style: MDStyle) -> some View {
        environment(\.mdStyle, style)
    }
    
    /// 修改指定样式字段
    func onMarkdownStyle<Value>(
        for target: MDStyleTarget<Value>,
        _ update: @escaping (inout Value) -> Void
    ) -> some View {
        modifier(MDPartStyleModifier(target: target, update: update))
    }
    
    /// 修改整体 Markdown 样式
    func onMarkdownStyle(
        _ update: @escaping (inout MDStyle) -> Void
    ) -> some View {
        modifier(MDStyleModifier(update: update))
    }
}
