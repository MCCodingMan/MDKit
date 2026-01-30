import SwiftUI

/// Markdown 渲染协议，将块模型转换为视图
@MainActor
public protocol MDRendering {
    /// 根据块模型创建对应的视图
    static func makeBlockView(
        block: MDBlock
    ) -> MDBlockView
}
