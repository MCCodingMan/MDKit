import SwiftUI

public struct MDUnknownKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        EmptyView().mdEraseToAnyView()
    }
}
