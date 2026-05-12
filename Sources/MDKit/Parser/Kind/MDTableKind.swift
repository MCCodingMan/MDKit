import SwiftUI

public struct MDTableKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.table.body {
            body(node)
        } else {
            MDTableView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
