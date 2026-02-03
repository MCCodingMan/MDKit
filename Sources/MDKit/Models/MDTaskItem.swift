//
//  MDTaskItem.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

public struct MDTaskItem: Hashable, Sendable {
    public let checked: Bool
    public let text: String
    public let depthPath: [Int]
    public let blocks: [MDBlock]

    public init(checked: Bool, text: String, depthPath: [Int], blocks: [MDBlock] = []) {
        self.checked = checked
        self.text = text
        self.depthPath = depthPath
        self.blocks = blocks
    }
}
