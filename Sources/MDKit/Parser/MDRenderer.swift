import SwiftUI

/// 默认渲染器，负责输出块级视图

public struct MDRenderer {
    
    /// 禁止外部实例化，仅提供静态渲染入口
    private init() {}
    
    /// 创建块级视图
    @MainActor public static func makeBlockView(
        block: MDBlock
    ) -> some View {
        MDBlockView(
            item: MDBlockItem(block: block, index: 0),
        )
    }
    
    /// 创建块级视图
    @MainActor public static func makeBlockView(
        item: MDBlockItem
    ) -> some View {
        MDBlockView(item: item)
    }
}
