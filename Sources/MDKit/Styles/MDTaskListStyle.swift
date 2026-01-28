import SwiftUI

/// 任务列表上下文
public struct MDTaskListContext {
    /// 任务项集合
    public let items: [MDTaskItem]

    /// 创建任务列表上下文
    public init(items: [MDTaskItem]) {
        self.items = items
    }
}

/// 任务列表样式配置
public struct MDTaskListStyle: MDContentStyle {
    
    
    /// 任务标记样式
    public struct MarkerStyle {
        /// 自定义标记视图
        public var markerView: ((MDListMarkerContext) -> AnyView)?
        /// 勾选颜色
        public var checkedColor: () -> Color
        /// 未勾选颜色
        public var uncheckedColor: () -> Color
        
        /// 创建任务标记样式
        public init(
            markerView: ((MDListMarkerContext) -> AnyView)? = nil,
            checkedColor: @escaping () -> Color,
            uncheckedColor: @escaping () -> Color
        ) {
            self.markerView = markerView
            self.checkedColor = checkedColor
            self.uncheckedColor = uncheckedColor
        }
    }
    
    /// 任务列表布局样式
    public struct ViewStyle {
        /// 列表项间距
        public var itemSpacing: () -> CGFloat
        /// 标记与内容间距
        public var markerSpacing: () -> CGFloat
        /// 缩进
        public var indent: () -> CGFloat
        
        /// 创建任务列表布局样式
        public init(
            itemSpacing: @escaping () -> CGFloat,
            markerSpacing: @escaping () -> CGFloat,
            indent: @escaping () -> CGFloat
        ) {
            self.itemSpacing = itemSpacing
            self.markerSpacing = markerSpacing
            self.indent = indent
        }
    }
    
    /// 输入上下文类型
    public typealias Value = MDTaskListContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var text: MDTextStyle
    /// 标记样式
    public var marker: MarkerStyle
    /// 布局样式
    public var view: ViewStyle

    /// 创建任务列表样式
    public init(
        body: bodyBuilder? = nil,
        text: MDTextStyle,
        marker: MarkerStyle,
        view: ViewStyle
    ) {
        self.body = body
        self.text = text
        self.marker = marker
        self.view = view
    }
}
