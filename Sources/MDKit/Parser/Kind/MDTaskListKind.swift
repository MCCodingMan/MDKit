import SwiftUI

public struct MDTaskListKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        if let body = style.taskList.body {
            body(node)
        } else {
            MDTaskListView(
                style: style,
                node: node
            )
            .mdEraseToAnyView()
        }
    }
}
