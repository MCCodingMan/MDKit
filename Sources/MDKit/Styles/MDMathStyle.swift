import SwiftUI

/// 数学公式样式配置
public struct MDMathStyle: MDContentStyle {
    /// 输入公式文本
    public typealias Value = String
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var text: MDTextStyle
    
    public var renderAnimate: @Sendable () -> Animation?

    /// 创建数学公式样式
    public init(body: bodyBuilder? = nil, text: MDTextStyle, renderAnimate: @escaping @Sendable () -> Animation?) {
        self.body = body
        self.text = text
        self.renderAnimate = renderAnimate
    }
}
