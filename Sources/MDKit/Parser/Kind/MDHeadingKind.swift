import SwiftUI

public struct MDHeadingKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if case let .heading(level, _) = node.content {
            if let body = headingStyle(for: level, style: style).body {
                body(node)
            } else {
                MDHeadingView(
                    style: style,
                    node: node
                )
                .mdEraseToAnyView()
            }
        } else {
            EmptyView()
                .mdEraseToAnyView()
        }
    }
    
    private func headingStyle(for level: Int, style: MDStyle) -> MDTextDetailStyle {
        switch level {
        case 1: return style.header1
        case 2: return style.header2
        case 3: return style.header3
        case 4: return style.header4
        case 5: return style.header5
        default: return style.header6
        }
    }
}
