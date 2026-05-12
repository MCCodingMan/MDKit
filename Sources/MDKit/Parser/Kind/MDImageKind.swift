import SwiftUI

public struct MDImageKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.image.body {
            body(node)
        } else {
            MDImageView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
