//
//  MDEdgePaddingModifier.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

import SwiftUI

private struct MDEdgePaddingModifier: ViewModifier {
    let padding: [Edge: CGFloat?]

    func body(content: Content) -> some View {
        padding.reduce(AnyView(content)) { view, item in
            let (edge, value) = item
            if let value {
                return AnyView(view.padding(edgeSet(for: edge), value))
            } else {
                return AnyView(view)
            }
        }
    }

    private func edgeSet(for edge: Edge) -> Edge.Set {
        switch edge {
        case .top:
            return .top
        case .leading:
            return .leading
        case .bottom:
            return .bottom
        case .trailing:
            return .trailing
        }
    }
}

extension View {
    func mdEdgePadding(_ padding: [Edge: CGFloat?]) -> some View {
        modifier(MDEdgePaddingModifier(padding: padding))
    }
}

