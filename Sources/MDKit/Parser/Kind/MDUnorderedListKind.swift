import SwiftUI

public struct MDUnorderedListKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.unorderedList.body {
            body(node)
        } else {
            MDUnorderlListView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
