import SwiftUI

public struct MDMathInlineKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.mathInline.body {
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
