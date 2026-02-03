//
//  MDQuoteStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

/// 引用块样式配置
public struct MDQuoteStyle: MDContentStyle {
    
    /// 引用块视图样式
    public struct ViewStyle : Sendable{
        /// 行间距
        public var lineSpacing: @Sendable () -> CGFloat
        /// 内边距
        public var padding: @Sendable () -> [Edge: CGFloat?]
        /// 背景色
        public var backgroundColor: @Sendable () -> Color
        /// 圆角
        public var cornerRadius: @Sendable () -> CGFloat
        /// 边框样式
        public var border: MDBorderStyle
        
        /// 创建引用块视图样式
        public init(lineSpacing: @escaping @Sendable () -> CGFloat, padding: @escaping @Sendable () -> [Edge: CGFloat?], backgroundColor: @escaping @Sendable () -> Color, cornerRadius: @escaping @Sendable () -> CGFloat, border: MDBorderStyle) {
            self.lineSpacing = lineSpacing
            self.padding = padding
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.border = border
        }
    }
    
    /// 引用竖线样式
    public struct LineStyle : Sendable{
        /// 竖线颜色
        public var color: @Sendable () -> Color
        /// 竖线宽度
        public var width: @Sendable () -> CGFloat
        /// 自定义竖线视图
        public var lineView: (@Sendable () -> AnyView)?
        
        /// 创建竖线样式
        public init(
            color: @escaping @Sendable () -> Color,
            width: @escaping @Sendable () -> CGFloat,
            lineView: (@Sendable () -> AnyView)? = nil
        ) {
            self.color = color
            self.width = width
            self.lineView = lineView
        }
    }
    
    /// 输入上下文类型
    public typealias Value = MDQuoteContext
    /// 渲染内容类型
    public typealias Content = AnyView
    /// 自定义渲染闭包
    public var body: bodyBuilder?
    /// 视图样式
    public var view: ViewStyle
    /// 竖线样式
    public var line: LineStyle
    /// 文本样式
    public var text: MDTextStyle

    /// 创建引用块样式
    public init(
        body: bodyBuilder? = nil,
        view: ViewStyle,
        line: LineStyle,
        text: MDTextStyle
    ) {
        self.body = body
        self.view = view
        self.line = line
        self.text = text
    }
}
