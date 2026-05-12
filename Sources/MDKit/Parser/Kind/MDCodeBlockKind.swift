import SwiftUI

public struct MDCodeBlockKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.code.body {
            body(node)
        } else {
            MDCodeView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
