import SwiftUI

/// Markdown 全局样式配置
public struct MDStyle: Sendable {
    /// 一级标题样式
    public var header1: MDTextDetailStyle
    /// 二级标题样式
    public var header2: MDTextDetailStyle
    /// 三级标题样式
    public var header3: MDTextDetailStyle
    /// 四级标题样式
    public var header4: MDTextDetailStyle
    /// 五级标题样式
    public var header5: MDTextDetailStyle
    /// 六级标题样式
    public var header6: MDTextDetailStyle
    /// 正文样式
    public var paragraph: MDTextDetailStyle
    /// 链接样式
    public var link: MDLinkStyle
    /// 行内文本样式
    public var inline: MDInlineTextStyle
    /// 引用样式
    public var quote: MDQuoteStyle
    /// 无序列表样式
    public var unorderedList: MDListStyle
    /// 有序列表样式
    public var orderedList: MDListStyle
    /// 任务列表样式
    public var taskList: MDTaskListStyle
    /// 代码块样式
    public var code: MDCodeStyle
    /// 图片样式
    public var image: MDImageStyle
    /// 表格样式
    public var table: MDTableStyle
    /// 分割线样式
    public var divider: MDDividerStyle
    /// 脚注样式
    public var footnote: MDFootnoteStyle
    /// 行内数学公式样式
    public var mathInline: MDMathStyle
    /// 块级数学公式样式
    public var mathBlock: MDMathStyle
    /// HTML 内容样式
    public var html: MDHtmlStyle
    /// 创建全局样式
    public init(
        header1: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 18, weight: .bold) },
                color: { .black }
            )
        ),
        header2: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 18, weight: .bold) },
                color: { .black }
            )
        ),
        header3: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16, weight: .semibold) },
                color: { .black }
            )
        ),
        header4: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16, weight: .semibold) },
                color: { .black }
            )
        ),
        header5: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16, weight: .medium) },
                color: { .black }
            )
        ),
        header6: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16, weight: .medium) },
                color: { .black }
            )
        ),
        paragraph: MDTextDetailStyle = MDTextDetailStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .black },
                lineSpacing: { 6 }
            )
        ),
        link: MDLinkStyle = MDLinkStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { Color(red: 0.1, green: 0.45, blue: 0.85) }
            )
        ),
        inline: MDInlineTextStyle = MDInlineTextStyle(
            code: MDInlineStyle(
                weight: { nil },
                textColor: { .green },
                backgroundColor: { .clear }
            ),
            emphasis: MDInlineStyle(
                weight: { nil },
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            strong: MDInlineStyle(
                weight: { .bold },
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            strikethrough: MDInlineStyle(
                weight: { .bold },
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            link: MDInlineStyle(
                weight: { nil },
                textColor: { Color(red: 0.1, green: 0.45, blue: 0.85) },
                backgroundColor: { .clear }
            )
        ),
        quote: MDQuoteStyle = MDQuoteStyle(
            body: nil,
            view: MDQuoteStyle.ViewStyle(
                lineSpacing: { 8 },
                padding: { [.top: 16, .bottom: 16, .leading: 16, .trailing: 16] },
                backgroundColor: { .gray.opacity(0.1) },
                cornerRadius: { 8 },
                border: MDBorderStyle(
                    color: { .gray.opacity(0.3) },
                    width: { 1 },
                    cornerRadius: { 8 }
                )
            ),
            line: MDQuoteStyle.LineStyle(
                color: { .gray.opacity(0.3) },
                width: { 3 },
                lineView: nil
            ),
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { Color(red: 120 / 255.0, green: 120 / 255.0, blue: 120 / 255.0) }
            )
        ),
        unorderedList: MDListStyle = MDListStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .black }
            ),
            marker: MDListStyle.MarkerStyle(
                markerView: nil,
                markerFont: { .system(size: 16) },
                markerColor: { .black }
            ),
            view: MDListStyle.ViewStyle(
                itemSpacing: { 6 },
                markerSpacing: { 8 },
                indent: { 16 }
            )
        ),
        orderedList: MDListStyle = MDListStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .black }
            ),
            marker: MDListStyle.MarkerStyle(
                markerView: nil,
                markerFont: { .system(size: 16) },
                markerColor: { .black }
            ),
            view: MDListStyle.ViewStyle(
                itemSpacing: { 6 },
                markerSpacing: { 8 },
                indent: { 16 }
            )
        ),
        taskList: MDTaskListStyle = MDTaskListStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .black }
            ),
            marker: MDTaskListStyle.MarkerStyle(
                markerView: nil,
                checkedColor: { Color(red: 0.1, green: 0.45, blue: 0.85) },
                uncheckedColor: { .secondary }
            ),
            view: MDTaskListStyle.ViewStyle(
                itemSpacing: { 6 },
                markerSpacing: { 8 },
                indent: { 8 }
            )
        ),
        code: MDCodeStyle = MDCodeStyle(
            body: nil,
            view: MDCodeStyle.ViewStyle(
                languageView: MDCodeStyle.LanguageViewStyle(
                    view: nil,
                    text: MDTextStyle(
                        font: { .system(size: 16) },
                        color: { .white }
                    ),
                    padding: { [.leading: 16, .trailing: 16, .top: 8, .bottom: 8] },
                    background: { Color(red: 249 / 255.0, green: 250 / 255.0, blue: 250 / 255.0).opacity(0.04) }
                ),
                contentView: MDCodeStyle.ContentViewStyle(
                    view: nil,
                    highlightCode: nil,
                    codeSingleHeight: { nil },
                    padding: { [.leading: 16, .trailing: 16, .top: 16, .bottom: 16] },
                    text: MDTextStyle(
                        font: { .system(size: 14).monospaced() },
                        color: { .white },
                        lineSpacing: { 4 }
                    ),
                    background: { .clear }
                )
            ),
            container: MDCodeStyle.ContainerStyle(
                backgroundColor: { Color(red: 20 / 255.0, green: 20 / 255.0, blue: 24 / 255.0) },
                cornerRadius: { 6 },
                border: MDBorderStyle(
                    color: { .black.opacity(0.5) },
                    width: { 1 },
                    cornerRadius: { 6 }
                ),
            )
        ),
        image: MDImageStyle = MDImageStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 14, weight: .medium) },
                color: { .secondary }
            ),
            view: MDImageStyle.ViewStyle(
                loadingView: nil,
                failureView: nil
            ),
            layout: MDImageStyle.LayoutStyle(
                cornerRadius: { 8 },
                titleSpacing: { 6 },
                titleAlignment: { .center },
                height: { nil }
            )
        ),
        table: MDTableStyle = MDTableStyle(
            body: nil,
            text: MDTableStyle.TextStyle(
                headerText: MDTextStyle(
                    font: { .system(size: 16) },
                    color: { .black }
                ),
                bodyText: MDTextStyle(
                    font: { .system(size: 16) },
                    color: { .secondary }
                )
            ),
            view: MDTableStyle.ViewStyle(
                headerBackgroundColor: { Color.black.opacity(0.05) },
                bodyBackgroundColor: { .clear },
                cornerRadius: { 6 },
                border: MDBorderStyle(
                    color: { .gray.opacity(0.3) },
                    width: { 1 },
                    cornerRadius: { 6 }
                ),
                cellPadding: { [.leading: 12, .trailing: 12, .top: 8, .bottom: 8] },
                cellMaxWidth: { nil },
                headerLine: MDTableStyle.LineStyle(
                    lineWidth: { 0 },
                    lineColor: { .clear }
                ),
                bodyLine: MDTableStyle.LineStyle(
                    lineWidth: { 1 },
                    lineColor: { .gray.opacity(0.1) }
                ),
                cellAlignment: { .leading }
            )
        ),
        divider: MDDividerStyle = MDDividerStyle(
            body: nil,
            line: MDDividerStyle.LineStyle(
                color: { .black.opacity(0.6) },
                height: { 1 },
                padding: { [.top: 8, .bottom: 8] }
            )
        ),
        footnote: MDFootnoteStyle = MDFootnoteStyle(
            body: nil,
            textStyle: MDFootnoteStyle.TextStyle(
                label: MDTextStyle(
                    font: { .system(size: 12, weight: .medium) },
                    color: { .secondary }
                ),
                content: MDTextStyle(
                    font: { .body },
                    color: { .primary }
                )
            ),
            viewStyle: MDFootnoteStyle.ViewStyle(
                spacing: { 6 }
            )
        ),
        mathInline: MDMathStyle = MDMathStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .red },
            ),
            renderAnimate: { .default }
        ),
        mathBlock: MDMathStyle = MDMathStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .red }
            ),
            renderAnimate: { .default }
        ),
        html: MDHtmlStyle = MDHtmlStyle(
            body: nil
        )
    ) {
        self.header1 = header1
        self.header2 = header2
        self.header3 = header3
        self.header4 = header4
        self.header5 = header5
        self.header6 = header6
        self.paragraph = paragraph
        self.link = link
        self.inline = inline
        self.quote = quote
        self.unorderedList = unorderedList
        self.orderedList = orderedList
        self.taskList = taskList
        self.code = code
        self.image = image
        self.table = table
        self.divider = divider
        self.footnote = footnote
        self.mathInline = mathInline
        self.mathBlock = mathBlock
        self.html = html
    }

    /// 默认样式
    public static let defaultStyle = MDStyle()
}

/// 样式目标类型
public struct MDStyleTarget<Value> {
    /// 样式字段路径
    let keyPath: WritableKeyPath<MDStyle, Value>

    /// 创建样式目标
    public init(_ keyPath: WritableKeyPath<MDStyle, Value>) {
        self.keyPath = keyPath
    }
}

/// 文字类样式目标
public extension MDStyleTarget where Value == MDTextDetailStyle {
    static var header1: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header1) }
    static var header2: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header2) }
    static var header3: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header3) }
    static var header4: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header4) }
    static var header5: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header5) }
    static var header6: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.header6) }
    static var paragraph: MDStyleTarget<MDTextDetailStyle> { MDStyleTarget(\.paragraph) }
}

public extension MDStyleTarget where Value == MDLinkStyle {
    static var link: MDStyleTarget<MDLinkStyle> { MDStyleTarget(\.link) }
}

/// 行内样式目标
public extension MDStyleTarget where Value == MDInlineTextStyle {
    static var inline: MDStyleTarget<MDInlineTextStyle> { MDStyleTarget(\.inline) }
}

/// 引用样式目标
public extension MDStyleTarget where Value == MDQuoteStyle {
    static var quote: MDStyleTarget<MDQuoteStyle> { MDStyleTarget(\.quote) }
}

/// 列表样式目标
public extension MDStyleTarget where Value == MDListStyle {
    static var unorderedList: MDStyleTarget<MDListStyle> { MDStyleTarget(\.unorderedList) }
    static var orderedList: MDStyleTarget<MDListStyle> { MDStyleTarget(\.orderedList) }
}

/// 任务列表样式目标
public extension MDStyleTarget where Value == MDTaskListStyle {
    static var taskList: MDStyleTarget<MDTaskListStyle> { MDStyleTarget(\.taskList) }
}

/// 代码块样式目标
public extension MDStyleTarget where Value == MDCodeStyle {
    static var code: MDStyleTarget<MDCodeStyle> { MDStyleTarget(\.code) }
}

/// 图片样式目标
public extension MDStyleTarget where Value == MDImageStyle {
    static var image: MDStyleTarget<MDImageStyle> { MDStyleTarget(\.image) }
}

/// 表格样式目标
public extension MDStyleTarget where Value == MDTableStyle {
    static var table: MDStyleTarget<MDTableStyle> { MDStyleTarget(\.table) }
}

/// 分割线样式目标
public extension MDStyleTarget where Value == MDDividerStyle {
    static var divider: MDStyleTarget<MDDividerStyle> { MDStyleTarget(\.divider) }
}

/// 脚注样式目标
public extension MDStyleTarget where Value == MDFootnoteStyle {
    static var footnote: MDStyleTarget<MDFootnoteStyle> { MDStyleTarget(\.footnote) }
}

/// 数学公式样式目标
public extension MDStyleTarget where Value == MDMathStyle {
    static var mathInline: MDStyleTarget<MDMathStyle> { MDStyleTarget(\.mathInline) }
    static var mathBlock: MDStyleTarget<MDMathStyle> { MDStyleTarget(\.mathBlock) }
}

/// HTML 内容样式目标
public extension MDStyleTarget where Value == MDHtmlStyle {
    static var html: MDStyleTarget<MDHtmlStyle> { MDStyleTarget(\.html) }
}

/// 样式环境键
private struct MDStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = MDStyle.defaultStyle
}

/// 环境变量扩展
public extension EnvironmentValues {
    /// Markdown 样式
    var mdStyle: MDStyle {
        get { self[MDStyleEnvironmentKey.self] }
        set { self[MDStyleEnvironmentKey.self] = newValue }
    }
}
