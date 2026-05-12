import SwiftUI

public struct MDLinkKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.link.body {
            body(node)
        } else {
            MDLinkView(style: style, node: node)
                .mdEraseToAnyView()
        }
    }
}
