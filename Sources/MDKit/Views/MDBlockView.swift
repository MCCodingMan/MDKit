import SwiftUI
import UIKit
import LaTeXSwiftUI

public struct MDBlockView: View {
    let block: MDBlock
    @Environment(\.mdStyle) private var style
    
    public init(block: MDBlock) {
        self.block = block
    }
    
    public var body: some View {
        blockView
    }
    
    @ViewBuilder
    private var blockView: some View {
        switch block {
        case let .heading(level, text):
            let headingStyle = headingStyleFor(level)
            MDTextView(
                text: text,
                textStyle: headingStyle,
                inlineTextStyle: style.inline
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        case let .paragraph(text):
            MDTextView(
                text: text,
                textStyle: style.paragraph,
                inlineTextStyle: style.inline
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        case let .quote(lines):
            if let body = style.quote.body {
                body(MDQuoteContext(lines: lines))
            } else {
                HStack(alignment: .top, spacing: style.quote.view.lineSpacing()) {
                    quoteLineView(style.quote.line)
                    VStack(alignment: .leading, spacing: style.quote.view.lineSpacing()) {
                        ForEach(lines.indices, id: \.self) { index in
                            MDTextView(
                                text: lines[index],
                                textStyle: style.quote.text,
                                inlineTextStyle: style.inline
                            )
                        }
                    }
                    Spacer(minLength: 0)
                }
                .mdEdgePadding(style.quote.view.padding())
                .background(style.quote.view.backgroundColor())
                .radiusBorder(style: style.quote.view.border)
            }
        case let .unorderedList(items):
            if let body = style.unorderedList.body {
                body(MDListContext(items: items))
            } else {
                VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                            HStack(alignment: .top, spacing: style.unorderedList.view.markerSpacing()) {
                                listMarkerView(
                                    style: style.unorderedList.marker,
                                    context: MDListMarkerContext(
                                        index: index,
                                        checked: nil,
                                        depthPath: item.depthPath
                                    ),
                                    defaultText: "•"
                                )
                                if item.text.isEmpty == false {
                                    MDTextView(
                                        text: item.text,
                                        textStyle: style.unorderedList.text,
                                        inlineTextStyle: style.inline
                                    )
                                }
                            }
                            if item.blocks.isEmpty == false {
                                VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                                    ForEach(item.blocks.indices, id: \.self) { blockIndex in
                                        MDRenderer.makeBlockView(
                                            block: item.blocks[blockIndex],
                                        )
                                    }
                                }
                                .padding(.leading, style.unorderedList.view.indent())
                            }
                        }
                        .padding(.leading, CGFloat(listIndentLevel(item.depthPath)) * style.unorderedList.view.indent())
                    }
                }
            }
        case let .orderedList(items):
            if let body = style.orderedList.body {
                body(MDListContext(items: items))
            } else {
                VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        let number = item.depthPath.last ?? (index + 1)
                        VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                            HStack(alignment: .top, spacing: style.orderedList.view.markerSpacing()) {
                                listMarkerView(
                                    style: style.orderedList.marker,
                                    context: MDListMarkerContext(
                                        index: index,
                                        checked: nil,
                                        depthPath: item.depthPath
                                    ),
                                    defaultText: "\(number)."
                                )
                                if item.text.isEmpty == false {
                                    MDTextView(
                                        text: item.text,
                                        textStyle: style.orderedList.text,
                                        inlineTextStyle: style.inline
                                    )
                                }
                            }
                            if item.blocks.isEmpty == false {
                                VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                                    ForEach(item.blocks.indices, id: \.self) { blockIndex in
                                        MDRenderer.makeBlockView(
                                            block: item.blocks[blockIndex],
                                        )
                                    }
                                }
                                .padding(.leading, style.orderedList.view.indent())
                            }
                        }
                        .padding(.leading, CGFloat(listIndentLevel(item.depthPath)) * style.orderedList.view.indent())
                    }
                }
            }
        case let .taskList(items):
            if let body = style.taskList.body {
                body(MDTaskListContext(items: items))
            } else {
                VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                            HStack(alignment: .top, spacing: style.taskList.view.markerSpacing()) {
                                taskMarkerView(
                                    style: style.taskList.marker,
                                    context: MDListMarkerContext(
                                        index: index,
                                        checked: item.checked,
                                        depthPath: item.depthPath
                                    ),
                                    checked: item.checked
                                )
                                if item.text.isEmpty == false {
                                    MDTextView(
                                        text: item.text,
                                        textStyle: style.taskList.text,
                                        inlineTextStyle: style.inline
                                    )
                                }
                            }
                            if item.blocks.isEmpty == false {
                                VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                                    ForEach(item.blocks.indices, id: \.self) { blockIndex in
                                        MDRenderer.makeBlockView(
                                            block: item.blocks[blockIndex],
                                        )
                                    }
                                }
                                .padding(.leading, style.taskList.view.indent())
                            }
                        }
                        .padding(.leading, CGFloat(listIndentLevel(item.depthPath)) * style.taskList.view.indent())
                    }
                }
            }
        case let .code(language, code):
            if let body = style.code.body {
                body(MDCodeBlockContext(code: code, language: language))
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    if let language, language.isEmpty == false {
                        if let languageView = style.code.view.languageView.view {
                            languageView(language)
                        } else {
                            HStack(spacing: 0) {
                                Text(language)
                                    .font(style.code.view.languageView.text.font())
                                    .foregroundColor(style.code.view.languageView.text.color())
                                    .mdEdgePadding(style.code.view.languageView.padding())
                                Spacer()
                            }
                            .background(style.code.view.languageView.background())
                        }
                    }
                    if let contentView = style.code.view.contentView.view {
                        contentView(code, language)
                    } else {
                        MDCodeBlockView(code: code, language: language, style: style.code)
                    }
                }
                .background(style.code.container.backgroundColor())
                .radiusBorder(style: style.code.container.border)
            }
        case let .link(title, url):
            Link(title, destination: URL(string: url) ?? URL(string: "about:blank")!)
                .font(style.link.font())
                .foregroundColor(style.link.color())
        case let .image(alt, url, title):
            if let body = style.image.body {
                body(MDImageContext(alt: alt, url: url, title: title))
            } else {
                VStack(alignment: .leading, spacing: style.image.layout.titleSpacing()) {
                    MDCachedAsyncImage(url: URL(string: url)) { phase in
                        switch phase {
                        case .empty:
                            if let loadingView = style.image.view.loadingView {
                                loadingView()
                            } else {
                                ProgressView()
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(style.image.layout.cornerRadius())
                        case .failure:
                            if let failureView = style.image.view.failureView {
                                failureView()
                            } else {
                                Color.gray.opacity(0.2)
                                    .frame(height: style.image.layout.placeholderHeight())
                            }
                        @unknown default:
                            if let failureView = style.image.view.failureView {
                                failureView()
                            } else {
                                Color.gray.opacity(0.2)
                                    .frame(height: style.image.layout.placeholderHeight())
                            }
                        }
                    }
                    if let title, title.isEmpty == false {
                        Text(title)
                            .font(style.image.text.font())
                            .foregroundColor(style.image.text.color())
                            .frame(maxWidth: .infinity, alignment: style.image.layout.titleAlignment())
                    }
                }
            }
        case let .table(headers, rows):
            if let body = style.table.body {
                body(MDTableContext(headers: headers, rows: rows))
            } else {
                MDTableView(
                    headers: headers.map { MDTableView.CellData(text: $0) },
                    rows: rows.map { $0.map({ MDTableView.CellData(text: $0) }) },
                    style: style.table
                )
            }
        case .divider:
            if let body = style.divider.body {
                body(())
            } else {
                Rectangle()
                    .fill(style.divider.line.color())
                    .frame(height: style.divider.line.height())
                    .mdEdgePadding(style.divider.line.padding())
            }
        case let .html(content):
            MDHTMLView(text: content)
                .frame(maxWidth: .infinity, alignment: .leading)
        case let .footnote(label, content):
            if let body = style.footnote.body {
                body(MDFootnoteContext(label: label, content: content))
            } else {
                HStack(alignment: .top, spacing: style.footnote.viewStyle.spacing()) {
                    Text("[\(label)]")
                        .font(style.footnote.textStyle.label.font())
                        .foregroundColor(style.footnote.textStyle.label.color())
                    MDTextView(
                        text: content,
                        textStyle: style.footnote.textStyle.content,
                        inlineTextStyle: style.inline
                    )
                }
            }
        case let .mathInline(content):
            if let body = style.mathInline.body {
                body(decodeMath(content))
            } else {
                LaTeX(decodeMath(content))
                    .font(style.mathInline.text.font())
                    .renderingStyle(.original)
                    .renderingAnimation(.easeInOut)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        case let .mathBlock(content):
            if let body = style.mathBlock.body {
                body(decodeMath(content))
            } else {
                LaTeX(decodeMath(content))
                    .font(style.mathBlock.text.font())
                    .renderingStyle(.original)
                    .renderingAnimation(.easeInOut)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        case let .mermaid(content):
            if let body = style.mermaid.body {
                body(content)
            } else {
                EmptyView()
            }
        }
    }
    
    private func headingStyleFor(_ level: Int) -> MDTextStyle {
        switch level {
        case 1: return style.header1
        case 2: return style.header2
        case 3: return style.header3
        case 4: return style.header4
        case 5: return style.header5
        default: return style.header6
        }
    }
    
    private func decodeMath(_ content: String) -> String {
        let pattern = #"\$\$.*?\$\$|\$.*?\$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return MDLatexParser.removeNewLinePlaceholder(text: content)
        }
        var text = content
        let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regex.matches(in: text, range: nsRange)
        for match in matches.reversed() {
            guard let range = Range(match.range, in: text) else { continue }
            let token = String(text[range])
            if token.hasPrefix("$$"), token.hasSuffix("$$"), token.count >= 4 {
                let inner = String(token.dropFirst(2).dropLast(2))
                let decoded = MDLatexParser.removeNewLinePlaceholder(text: inner)
                text.replaceSubrange(range, with: "$$\(decoded)$$")
            } else if token.hasPrefix("$"), token.hasSuffix("$"), token.count >= 2 {
                let inner = String(token.dropFirst().dropLast())
                let decoded = MDLatexParser.removeNewLinePlaceholder(text: inner)
                text.replaceSubrange(range, with: "$\(decoded)$")
            }
        }
        return text
    }

    private func listIndentLevel(_ depthPath: [Int]) -> Int {
        max(0, depthPath.count - 1)
    }
    
    @ViewBuilder
    private func quoteLineView(_ style: MDQuoteStyle.LineStyle) -> some View {
        if let lineView = style.lineView {
            lineView()
        } else {
            Rectangle()
                .fill(style.color())
                .frame(width: style.width())
        }
    }
    
    @ViewBuilder
    private func listMarkerView(
        style: MDListStyle.MarkerStyle,
        context: MDListMarkerContext,
        defaultText: String
    ) -> some View {
        if let markerView = style.markerView {
            markerView(context)
        } else {
            Text(defaultText)
                .font(style.markerFont())
                .foregroundColor(style.markerColor())
        }
    }
    
    @ViewBuilder
    private func taskMarkerView(
        style: MDTaskListStyle.MarkerStyle,
        context: MDListMarkerContext,
        checked: Bool
    ) -> some View {
        if let markerView = style.markerView {
            markerView(context)
        } else {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? style.checkedColor() : style.uncheckedColor())
        }
    }
    
    private func defaultCopyText(for block: MDBlock) -> String? {
        switch block {
        case let .heading(_, text):
            return text
        case let .paragraph(text):
            return text
        case let .quote(lines):
            return lines.joined(separator: "\n")
        case let .unorderedList(items):
            return items.map { listItemCopyText(text: $0.text, blocks: $0.blocks) }.joined(separator: "\n")
        case let .orderedList(items):
            return items.map { listItemCopyText(text: $0.text, blocks: $0.blocks) }.joined(separator: "\n")
        case let .taskList(items):
            return items.map { "\($0.checked ? "[x]" : "[ ]") \(listItemCopyText(text: $0.text, blocks: $0.blocks))" }.joined(separator: "\n")
        case let .code(_, code):
            return code
        case let .link(title, url):
            return "\(title) \(url)"
        case let .image(alt, url, _):
            return "\(alt) \(url)"
        case let .table(headers, rows):
            let headerLine = headers.joined(separator: " | ")
            let rowLines = rows.map { $0.joined(separator: " | ") }
            return ([headerLine] + rowLines).joined(separator: "\n")
        case .divider:
            return nil
        case let .html(content):
            return content
        case let .footnote(label, content):
            return "[\(label)] \(content)"
        case let .mathInline(content):
            return content
        case let .mathBlock(content):
            return content
        case let .mermaid(content):
            return content
        }
    }
    
    private func listItemCopyText(text: String, blocks: [MDBlock]) -> String {
        var parts: [String] = []
        if text.isEmpty == false {
            parts.append(text)
        }
        let nested = blocks.compactMap { defaultCopyText(for: $0) }
        if nested.isEmpty == false {
            parts.append(contentsOf: nested)
        }
        return parts.joined(separator: "\n")
    }
}
