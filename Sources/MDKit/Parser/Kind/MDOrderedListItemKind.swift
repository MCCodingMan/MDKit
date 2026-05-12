import SwiftUI

public struct MDOrderedListItemKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        MDOrderListItemView(style: style, node: node)
            .mdEraseToAnyView()
    }
}
