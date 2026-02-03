import SwiftUI

struct MDBlockView: View {
    @Environment(\.mdStyle) private var style
    let item: MDBlockItem
    
    var body: some View {
        blockView
    }
    
    private var blockView: AnyView {
        switch item.block {
        case .heading(let context):
            if let body = headingStyle(for: context.level).body {
                return AnyView(body(MDTextDetailContext(text: context.text)))
            }
            return AnyView(
                MDHeadingView(
                    style: style,
                    level: context.level,
                    text: context.text
                )
            )
        case .paragraph(let context):
            if let body = style.paragraph.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDParagraphView(
                    style: style,
                    text: context.text
                )
            )
        case .quote(let context):
            if let body = style.quote.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDQuoteView(
                    style: style,
                    lines: context.lines
                )
            )
        case .unorderedList(let context):
            if let body = style.unorderedList.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDUnorderlListView(
                    style: style,
                    items: context.items
                )
            )
        case .orderedList(let context):
            if let body = style.orderedList.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDOrderListView(
                    style: style,
                    items: context.items
                )
            )
        case .taskList(let context):
            if let body = style.taskList.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDTaskListView(
                    style: style,
                    items: context.items
                )
            )
        case .code(let context):
            if let body = style.code.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDCodeView(
                    style: style,
                    language: context.language,
                    code: context.code
                )
            )
        case .link(let context):
            if let body = style.link.body {
                return AnyView(body(context))
            }
            return AnyView(MDLinkView(style: style, url: context.url, title: context.title))
        case .image(let context):
            if let body = style.image.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDImageView(
                    style: style,
                    url: context.url,
                    title: context.title
                )
            )
        case .table(let context):
            if let body = style.table.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDTableView(
                    headers: context.headers.map {
                        MDTableView.CellData(text: $0)
                    },
                    rows: context.rows.map {
                        $0.map({
                            MDTableView.CellData(text: $0)
                        })
                    },
                    style: style.table
                )
            )
        case .divider:
            if let body = style.divider.body {
                return AnyView(body(()))
            }
            return AnyView(MDDividerView(style: style))
        case .html(let context):
            if let body = style.html.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDHTMLView(
                    text: context.text
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            )
        case .footnote(let context):
            if let body = style.footnote.body {
                return AnyView(body(context))
            }
            return AnyView(
                MDFootnoteView(
                    style: style,
                    label: context.label,
                    content: context.content
                )
            )
        case .mathInline(let context):
            if let body = style.mathInline.body {
                return AnyView(body(decodeMath(context.text)))
            }
            return AnyView(
                MDMathView(
                    style: style,
                    isInline: true,
                    content: decodeMath(context.text)
                )
            )
        case .mathBlock(let context):
            if let body = style.mathBlock.body {
                return AnyView(body(decodeMath(context.text)))
            }
            return AnyView(
                MDMathView(
                    style: style,
                    isInline: false,
                    content: decodeMath(context.text)
                )
            )
        }
    }
    
    func headingStyle(for level: Int) -> MDTextDetailStyle {
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
}
