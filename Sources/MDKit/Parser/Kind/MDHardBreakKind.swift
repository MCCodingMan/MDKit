import SwiftUI

public struct MDHardBreakKind: MDASTKind {
    public init() {}
    public func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView {
        MDTextView(
            text: "\n",
            textStyle: style.paragraph.text,
            inlineTextStyle: style.inline
        )
        .mdEraseToAnyView()
    }
}
