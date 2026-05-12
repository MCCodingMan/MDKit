import SwiftUI

public struct MDDocumentKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(node.children.enumerated()), id: \.offset) { _, child in
                MDBlockView(node: child)
            }
        }
        .mdEraseToAnyView()
    }
}
