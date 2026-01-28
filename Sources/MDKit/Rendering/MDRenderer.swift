import SwiftUI

@MainActor
public struct MDRenderer: MDRendering {
    
    private init() {}

    public static func makeBlockView(
        block: MDBlock,
        style: MDStyle,
    ) -> MDBlockView {
        MDBlockView(
            block: block,
            style: style,
        )
    }
}
