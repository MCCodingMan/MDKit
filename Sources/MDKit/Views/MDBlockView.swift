import SwiftUI

struct MDBlockView: View {
    @Environment(\.mdStyle) private var style
    let node: MDASTNode
    
    var body: some View {
        blockView
    }

    @ViewBuilder
    var blockView: some View {
        node.kind.makeKindBody(with: node, style: style)
    }
}

extension MDBlockView: Equatable {
    nonisolated static func == (lhs: MDBlockView, rhs: MDBlockView) -> Bool {
        lhs.node == rhs.node
    }
}
