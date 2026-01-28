//
//  MDListStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI


/// 列表标记上下文
public struct MDListMarkerContext {
    /// 当前序号
    public let index: Int
    /// 任务项勾选状态
    public let checked: Bool?
    /// 嵌套层级路径
    public let depthPath: [Int]
    
    /// 创建标记上下文
    public init(index: Int, checked: Bool?, depthPath: [Int]) {
        self.index = index
        self.checked = checked
        self.depthPath = depthPath
    }
}


/// 列表内容上下文
public struct MDListContext {
    /// 列表项集合
    public let items: [MDListItem]
    
    /// 创建列表上下文
    public init(items: [MDListItem]) {
        self.items = items
    }
}

extension MDListStyle {
    
    /// 列表布局样式
    public struct ViewStyle {
        /// 列表项间距
        public var itemSpacing: () -> CGFloat
        /// 标记与内容间距
        public var markerSpacing: () -> CGFloat
        /// 缩进
        public var indent: () -> CGFloat
        
        /// 创建列表布局样式
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
    
    /// 列表标记样式
    public struct MarkerStyle {
        /// 自定义标记视图
        public var markerView: ((MDListMarkerContext) -> AnyView)?
        /// 标记字体
        public var markerFont: () -> Font
        /// 标记颜色
        public var markerColor: () -> Color
        
        /// 创建列表标记样式
        public init(
            markerView: ((MDListMarkerContext) -> AnyView)? = nil,
            markerFont: @escaping () -> Font,
            markerColor: @escaping () -> Color
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
