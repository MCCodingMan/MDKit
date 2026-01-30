import SwiftUI

/// 默认渲染器，负责输出块级视图
@MainActor
public struct MDRenderer: MDRendering {
    /// 禁止外部实例化，仅提供静态渲染入口
    private init() {}

    /// 创建块级视图
    public static func makeBlockView(
        block: MDBlock
    ) -> MDBlockView {
        MDBlockView(
            block: block,
        )
    }
}
