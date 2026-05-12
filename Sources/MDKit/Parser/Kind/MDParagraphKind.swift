import SwiftUI

public struct MDParagraphKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.paragraph.body {
            body(node)
        } else {
            MDParagraphView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
