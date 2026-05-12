import SwiftUI

public struct MDBlockQuoteKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.quote.body {
            body(node)
        } else {
            MDQuoteView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
