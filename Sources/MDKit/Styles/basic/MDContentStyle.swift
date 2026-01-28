//
//  MDContentStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// Markdown 内容样式协议
public protocol MDContentStyle {
    /// 样式输入值类型
    associatedtype Value
    /// 样式渲染内容类型
    associatedtype Content: View
    
    /// 通过输入值构建视图
    typealias bodyBuilder = (Value) -> Content
    
    /// 自定义渲染闭包
    var body: bodyBuilder? { get set }
}
