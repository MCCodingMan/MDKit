import SwiftUI

public struct MDDividerKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.divider.body {
            body(node)
        } else {
            MDDividerView(style: style)
                .mdEraseToAnyView()
        }
    }
}
