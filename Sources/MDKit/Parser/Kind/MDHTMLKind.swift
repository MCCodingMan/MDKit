import SwiftUI

public struct MDHTMLKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.html.body {
            body(node)
        } else {
            MDHTMLView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
