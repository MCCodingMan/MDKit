//
//  MDRender.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/13.
//
import SwiftUI

public struct MDRender {
    static public func makeNodeView(node: MDASTNode) -> some View {
        MDBlockView(node: node)
            .equatable()
    }
}
