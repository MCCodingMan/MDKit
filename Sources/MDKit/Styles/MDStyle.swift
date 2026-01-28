import SwiftUI

public struct MDStyle {
    public var header1: MDTextStyle
    public var header2: MDTextStyle
    public var header3: MDTextStyle
    public var header4: MDTextStyle
    public var header5: MDTextStyle
    public var header6: MDTextStyle
    public var paragraph: MDTextStyle
    public var link: MDTextStyle
    public var inline: MDInlineTextStyle
    public var quote: MDQuoteStyle
    public var unorderedList: MDListStyle
    public var orderedList: MDListStyle
    public var taskList: MDTaskListStyle
    public var code: MDCodeStyle
    public var image: MDImageStyle
    public var table: MDTableStyle
    public var divider: MDDividerStyle
    public var footnote: MDFootnoteStyle
    public var mathInline: MDMathStyle
    public var mathBlock: MDMathStyle
    public var mermaid: MDMermaidStyle

    public init(
        header1: MDTextStyle = MDTextStyle(
            font: { .system(size: 18, weight: .bold) },
            color: { .black }
        ),
        header2: MDTextStyle = MDTextStyle(
            font: { .system(size: 18, weight: .bold) },
            color: { .black }
        ),
        header3: MDTextStyle = MDTextStyle(
            font: { .system(size: 16, weight: .semibold) },
            color: { .black }
        ),
        header4: MDTextStyle = MDTextStyle(
            font: { .system(size: 16, weight: .semibold) },
            color: { .black }
        ),
        header5: MDTextStyle = MDTextStyle(
            font: { .system(size: 16, weight: .medium) },
            color: { .black }
        ),
        header6: MDTextStyle = MDTextStyle(
            font: { .system(size: 16, weight: .medium) },
            color: { .black }
        ),
        paragraph: MDTextStyle = MDTextStyle(
            font: { .system(size: 16) },
            color: { .black }
        ),
        link: MDTextStyle = MDTextStyle(
            font: { .system(size: 16) },
            color: { Color(red: 0.1, green: 0.45, blue: 0.85) }
        ),
        inline: MDInlineTextStyle = MDInlineTextStyle(
            code: MDInlineStyle(
                textColor: { .green },
                backgroundColor: { .clear }
            ),
            emphasis: MDInlineStyle(
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            strong: MDInlineStyle(
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            strikethrough: MDInlineStyle(
                textColor: { .black },
                backgroundColor: { .clear }
            ),
            link: MDInlineStyle(
                textColor: { Color(red: 0.1, green: 0.45, blue: 0.85) },
                backgroundColor: { .clear }
            )
        ),
        quote: MDQuoteStyle = MDQuoteStyle(
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
                    background: { .black.opacity(0.88) }
                ),
                contentView: MDCodeStyle.ContentViewStyle(
                    view: nil,
                    highlightCode: nil,
                    codeSingleHeight: { 20 },
                    padding: { [.leading: 16, .trailing: 16, .top: 8, .bottom: 8] },
                    text: MDTextStyle(
                        font: { .system(size: 14).monospaced() },
                        color: { .white },
                        lineSpacing: { 6 }
                    ),
                    background: { .clear }
                )
            ),
            container: MDCodeStyle.ContainerStyle(
                backgroundColor: { .black.opacity(0.7) },
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
                placeholderHeight: { 0 }
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
                )
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
                color: { .red }
            )
        ),
        mathBlock: MDMathStyle = MDMathStyle(
            body: nil,
            text: MDTextStyle(
                font: { .system(size: 16) },
                color: { .red }
            )
        ),
        mermaid: MDMermaidStyle = MDMermaidStyle(
            body: nil,
            text: MDMermaidStyle.TextStyle(
                label: MDTextStyle(
                    font: { .system(size: 16) },
                    color: { .secondary }
                ),
                content: MDTextStyle(
                    font: { .system(size: 16) },
                    color: { .black }
                )
            ),
            view: MDMermaidStyle.ViewStyle(
                backgroundColor: { .black.opacity(0.5) },
                cornerRadius: { 6 },
                padding: { [:] }
            )
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
        self.mermaid = mermaid
    }

    nonisolated(unsafe) public static let defaultStyle = MDStyle()
}

public struct MDStyleTarget<Value> {
    let keyPath: WritableKeyPath<MDStyle, Value>

    public init(_ keyPath: WritableKeyPath<MDStyle, Value>) {
        self.keyPath = keyPath
    }
}

public extension MDStyleTarget where Value == MDTextStyle {
    static var header1: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header1) }
    static var header2: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header2) }
    static var header3: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header3) }
    static var header4: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header4) }
    static var header5: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header5) }
    static var header6: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.header6) }
    static var paragraph: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.paragraph) }
    static var link: MDStyleTarget<MDTextStyle> { MDStyleTarget(\.link) }
}

public extension MDStyleTarget where Value == MDInlineTextStyle {
    static var inline: MDStyleTarget<MDInlineTextStyle> { MDStyleTarget(\.inline) }
}

public extension MDStyleTarget where Value == MDQuoteStyle {
    static var quote: MDStyleTarget<MDQuoteStyle> { MDStyleTarget(\.quote) }
}

public extension MDStyleTarget where Value == MDListStyle {
    static var unorderedList: MDStyleTarget<MDListStyle> { MDStyleTarget(\.unorderedList) }
    static var orderedList: MDStyleTarget<MDListStyle> { MDStyleTarget(\.orderedList) }
}

public extension MDStyleTarget where Value == MDTaskListStyle {
    static var taskList: MDStyleTarget<MDTaskListStyle> { MDStyleTarget(\.taskList) }
}

public extension MDStyleTarget where Value == MDCodeStyle {
    static var code: MDStyleTarget<MDCodeStyle> { MDStyleTarget(\.code) }
}

public extension MDStyleTarget where Value == MDImageStyle {
    static var image: MDStyleTarget<MDImageStyle> { MDStyleTarget(\.image) }
}

public extension MDStyleTarget where Value == MDTableStyle {
    static var table: MDStyleTarget<MDTableStyle> { MDStyleTarget(\.table) }
}

public extension MDStyleTarget where Value == MDDividerStyle {
    static var divider: MDStyleTarget<MDDividerStyle> { MDStyleTarget(\.divider) }
}

public extension MDStyleTarget where Value == MDFootnoteStyle {
    static var footnote: MDStyleTarget<MDFootnoteStyle> { MDStyleTarget(\.footnote) }
}

public extension MDStyleTarget where Value == MDMathStyle {
    static var mathInline: MDStyleTarget<MDMathStyle> { MDStyleTarget(\.mathInline) }
    static var mathBlock: MDStyleTarget<MDMathStyle> { MDStyleTarget(\.mathBlock) }
}

public extension MDStyleTarget where Value == MDMermaidStyle {
    static var mermaid: MDStyleTarget<MDMermaidStyle> { MDStyleTarget(\.mermaid) }
}

private struct MDStyleEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = MDStyle.defaultStyle
}

public extension EnvironmentValues {
    var mdStyle: MDStyle {
        get { self[MDStyleEnvironmentKey.self] }
        set { self[MDStyleEnvironmentKey.self] = newValue }
    }
}

private struct MDPartStyleModifier<Value>: ViewModifier {
    @Environment(\.mdStyle) private var style
    let target: MDStyleTarget<Value>
    let update: (inout Value) -> Void

    func body(content: Content) -> some View {
        var updated = style
        update(&updated[keyPath: target.keyPath])
        return content.environment(\.mdStyle, updated)
    }
}


private struct MDStyleModifier: ViewModifier {
    @Environment(\.mdStyle) private var style
    let update: (inout MDStyle) -> Void
    
    func body(content: Content) -> some View {
        var updated = style
        update(&updated)
        return content.environment(\.mdStyle, updated)
    }
}

public extension View {
    func mdStyle(_ style: MDStyle) -> some View {
        environment(\.mdStyle, style)
    }

    func onMarkdownStyle<Value>(
        for target: MDStyleTarget<Value>,
        _ update: @escaping (inout Value) -> Void
    ) -> some View {
        modifier(MDPartStyleModifier(target: target, update: update))
    }
    
    func onMarkdownStyle(
        _ update: @escaping (inout MDStyle) -> Void
    ) -> some View {
        modifier(MDStyleModifier(update: update))
    }
}
