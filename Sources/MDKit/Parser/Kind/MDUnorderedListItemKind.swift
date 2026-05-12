import SwiftUI

public struct MDUnorderedListItemKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        MDUnOrderListItemView(style: style, node: node)
            .mdEraseToAnyView()
    }
}
