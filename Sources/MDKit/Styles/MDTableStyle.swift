import SwiftUI

/// 表格内容上下文
public struct MDTableContext {
    /// 表头
    public let headers: [String]
    /// 行数据
    public let rows: [[String]]

    /// 创建表格上下文
    public init(headers: [String], rows: [[String]]) {
        self.headers = headers
        self.rows = rows
    }
}

/// 表格样式配置
public struct MDTableStyle: MDContentStyle {
    /// 输入上下文类型
    public typealias Value = MDTableContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 文本样式
    public var text: TextStyle
    /// 视图样式
    public var view: ViewStyle

    /// 创建表格样式
    public init(
        body: bodyBuilder? = nil,
        text: TextStyle,
        view: ViewStyle
    ) {
        self.body = body
        self.text = text
        self.view = view
    }
}

extension MDTableStyle {
    
    /// 表格文本样式
    public struct TextStyle {
        /// 表头文本样式
        public var headerText: MDTextStyle
        /// 内容文本样式
        public var bodyText: MDTextStyle
        
        /// 创建表格文本样式
        public init(headerText: MDTextStyle, bodyText: MDTextStyle) {
            self.headerText = headerText
            self.bodyText = bodyText
        }
    }
    
    /// 表格线条样式
    public struct LineStyle {
        /// 线宽
        public var lineWidth: () -> CGFloat
        /// 线色
        public var lineColor: () -> Color
        
        /// 创建线条样式
        public init(lineWidth: @escaping () -> CGFloat, lineColor: @escaping () -> Color) {
            self.lineWidth = lineWidth
            self.lineColor = lineColor
        }
    }
    
    
    /// 表格视图样式
    public struct ViewStyle {
        /// 表头背景色
        public var headerBackgroundColor: () -> Color
        /// 内容背景色
        public var bodyBackgroundColor: () -> Color
        /// 圆角
        public var cornerRadius: () -> CGFloat
        /// 边框样式
        public var border: MDBorderStyle
        /// 单元格内边距
        public var cellPadding: () -> [Edge: CGFloat?]
        /// 单元格最大宽度
        public var cellMaxWidth: () -> CGFloat?
        /// 表头分隔线
        public var headerLine: LineStyle
        /// 内容分隔线
        public var bodyLine: LineStyle
        /// 内容对齐方式
        public var cellAlignment: () -> Alignment
        
        /// 创建表格视图样式
        public init(headerBackgroundColor: @escaping () -> Color, bodyBackgroundColor: @escaping () -> Color, cornerRadius: @escaping () -> CGFloat, border: MDBorderStyle, cellPadding: @escaping () -> [Edge : CGFloat?], cellMaxWidth: @escaping () -> CGFloat?, headerLine: LineStyle, bodyLine: LineStyle, cellAlignment: @escaping () -> Alignment) {
            self.headerBackgroundColor = headerBackgroundColor
            self.bodyBackgroundColor = bodyBackgroundColor
            self.cornerRadius = cornerRadius
            self.border = border
            self.cellPadding = cellPadding
            self.cellMaxWidth = cellMaxWidth
            self.headerLine = headerLine
            self.bodyLine = bodyLine
            self.cellAlignment = cellAlignment
        }
    }
}
