import SwiftUI

public struct MDMathBlockKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.mathBlock.body {
            body(node)
        } else {
            MDMathView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
