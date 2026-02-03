import SwiftUI

extension MDDividerStyle {
    
    /// 分割线样式
    public struct LineStyle: Sendable {
        /// 线条颜色
        public var color: @Sendable () -> Color
        /// 线条高度
        public var height: @Sendable () -> CGFloat
        /// 外边距
        public var padding: @Sendable () -> [Edge: CGFloat?]
        
        /// 创建分割线样式
        public init(color: @escaping @Sendable () -> Color, height: @escaping @Sendable () -> CGFloat, padding: @escaping @Sendable () -> [Edge: CGFloat?]) {
            self.color = color
            self.height = height
            self.padding = padding
        }
    }
}

/// 分割线样式配置
public struct MDDividerStyle: MDContentStyle {
    /// 输入值类型
    public typealias Value = Void
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 线条样式
    public var line: LineStyle

    /// 创建分割线样式
    public init(
        body: bodyBuilder? = nil,
        line: LineStyle,
    ) {
        self.body = body
        self.line = line
    }
}
