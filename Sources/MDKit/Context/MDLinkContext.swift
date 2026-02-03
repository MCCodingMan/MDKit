//
//  MDLinkContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

public struct MDLinkContext: Hashable, Sendable {
    public let title: String
    public let url: String
    
    public init(title: String, url: String) {
        self.title = title
        self.url = url
    }
}
