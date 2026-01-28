import SwiftUI

/// 脚注内容上下文
public struct MDFootnoteContext {
    /// 脚注标识
    public let label: String
    /// 脚注内容
    public let content: String

    /// 创建脚注上下文
    public init(label: String, content: String) {
        self.label = label
        self.content = content
    }
}

extension MDFootnoteStyle {
    
    /// 脚注文本样式
    public struct TextStyle {
        /// 标识文本样式
        public var label: MDTextStyle
        /// 内容文本样式
        public var content: MDTextStyle
        
        /// 创建脚注文本样式
        public init(label: MDTextStyle, content: MDTextStyle) {
            self.label = label
            self.content = content
        }
    }
    
    /// 脚注布局样式
    public struct ViewStyle {
        /// 文本间距
        public var spacing: () -> CGFloat
        
        /// 创建脚注布局样式
        public init(spacing: @escaping () -> CGFloat) {
            self.spacing = spacing
        }
    }
}

/// 脚注样式配置
public struct MDFootnoteStyle: MDContentStyle {
    /// 输入上下文类型
    public typealias Value = MDFootnoteContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var textStyle: TextStyle
    /// 布局样式
    public var viewStyle: ViewStyle

    /// 创建脚注样式
    public init(
        body: bodyBuilder? = nil,
        textStyle: TextStyle,
        viewStyle: ViewStyle
    ) {
        self.body = body
        self.textStyle = textStyle
        self.viewStyle = viewStyle
    }
}
