//
//  MDImageContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

/// 图片内容上下文
public struct MDImageContext: Hashable, Sendable {
    /// 替代文本
    public let alt: String
    /// 图片地址
    public let url: String
    /// 标题
    public let title: String?

    /// 创建图片上下文
    public init(alt: String, url: String, title: String?) {
        self.alt = alt
        self.url = url
        self.title = title
    }
}
