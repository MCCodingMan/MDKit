import SwiftUI

@MainActor
public protocol MDRendering {
    static func makeBlockView(
        block: MDBlock,
        style: MDStyle,
    ) -> MDBlockView
}
