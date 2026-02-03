//
//  MDListItem.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

public struct MDListItem: Hashable, Sendable {
    public let text: String
    public let depthPath: [Int]
    public let blocks: [MDBlock]

    public init(text: String, depthPath: [Int], blocks: [MDBlock] = []) {
        self.text = text
        self.depthPath = depthPath
        self.blocks = blocks
    }
}
