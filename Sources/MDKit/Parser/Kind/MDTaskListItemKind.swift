import SwiftUI

public struct MDTaskListItemKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        MDTaskListItemView(style: style, node: node)
            .mdEraseToAnyView()
    }
}
