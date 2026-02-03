//
//  MDTextDetailContext.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

public struct MDTextDetailContext: Hashable, Sendable {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
}
