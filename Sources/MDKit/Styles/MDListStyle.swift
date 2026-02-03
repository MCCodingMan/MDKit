//
//  MDListStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI


extension MDListStyle {
    
    /// 列表布局样式
    public struct ViewStyle: Sendable{
        /// 列表项间距
        public var itemSpacing: @Sendable () -> CGFloat
        /// 标记与内容间距
        public var markerSpacing: @Sendable () -> CGFloat
        /// 缩进
        public var indent: @Sendable () -> CGFloat
        
        /// 创建列表布局样式
        public init(
            itemSpacing: @escaping @Sendable () -> CGFloat,
            markerSpacing: @escaping @Sendable () -> CGFloat,
            indent: @escaping @Sendable () -> CGFloat
        ) {
            self.itemSpacing = itemSpacing
            self.markerSpacing = markerSpacing
            self.indent = indent
        }
    }
    
    /// 列表标记样式
    public struct MarkerStyle: Sendable{
        /// 自定义标记视图
        public var markerView: (@Sendable (MDListMarkerContext) -> AnyView)?
        /// 标记字体
        public var markerFont: @Sendable () -> Font
        /// 标记颜色
        public var markerColor: @Sendable () -> Color
        
        /// 创建列表标记样式
        public init(
            markerView: (@Sendable (MDListMarkerContext) -> AnyView)? = nil,
            markerFont: @escaping @Sendable () -> Font,
            markerColor: @escaping @Sendable () -> Color
        ) {
            self.markerView = markerView
            self.markerFont = markerFont
            self.markerColor = markerColor
        }
    }
    
}

/// 列表样式配置
public struct MDListStyle: MDContentStyle {
    /// 输入上下文类型
    public typealias Value = MDListContext
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

    /// 创建列表样式
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
