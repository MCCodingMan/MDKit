import SwiftUI

public struct MDOrderedListKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.orderedList.body {
            body(node)
        } else {
            MDOrderListView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
