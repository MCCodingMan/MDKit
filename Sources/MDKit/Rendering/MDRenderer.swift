import SwiftUI

@MainActor
public struct MDRenderer: MDRendering {
    
    private init() {}

    public static func makeBlockView(
        block: MDBlock
    ) -> MDBlockView {
        MDBlockView(
            block: block,
        )
    }
}
