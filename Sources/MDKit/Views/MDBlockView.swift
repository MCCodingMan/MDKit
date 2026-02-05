import SwiftUI

struct MDBlockView: View {
    @Environment(\.mdStyle) private var style
    let item: MDBlockItem
    
    var body: some View {
        blockView
    }

    @ViewBuilder
    var blockView: some View {
        switch item.block {
        case .heading, .paragraph, .quote, .html, .divider:
            renderTextBlock
        case .unorderedList, .orderedList, .taskList:
            renderListBlock
        case .code, .link, .image, .table:
            renderMediaBlock
        case .footnote, .mathInline, .mathBlock:
            renderMiscBlock
        }
    }
    
    @ViewBuilder
    var renderTextBlock: some View {
        switch item.block {
        case .heading(let context):
            if let body = headingStyle(for: context.level).body {
                body(MDTextDetailContext(text: context.text))
            } else {
                MDHeadingView(
                    style: style,
                    level: context.level,
                    text: context.text
                )
            }
        case .paragraph(let context):
            if let body = style.paragraph.body {
                body(context)
            } else {
                MDParagraphView(
                    style: style,
                    text: context.text
                )
            }
        case .quote(let context):
            if let body = style.quote.body {
                body(context)
            } else {
                MDQuoteView(
                    style: style,
                    lines: context.lines
                )
            }
        case .html(let context):
            if let body = style.html.body {
                body(context)
            } else {
                MDHTMLView(
                    text: context.text
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        case .divider:
            if let body = style.divider.body {
                body(())
            } else {
                MDDividerView(style: style)
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var renderListBlock: some View {
        switch item.block {
        case .unorderedList(let context):
            if let body = style.unorderedList.body {
                body(context)
            } else {
                MDUnorderlListView(
                    style: style,
                    items: context.items
                )
            }
        case .orderedList(let context):
            if let body = style.orderedList.body {
                body(context)
            } else {
                MDOrderListView(
                    style: style,
                    items: context.items
                )
            }
        case .taskList(let context):
            if let body = style.taskList.body {
                body(context)
            } else {
                MDTaskListView(
                    style: style,
                    items: context.items
                )
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var renderMediaBlock: some View {
        switch item.block {
        case .code(let context):
            if let body = style.code.body {
                body(context)
            } else {
                MDCodeView(
                    style: style,
                    language: context.language,
                    code: context.code
                )
            }
        case .link(let context):
            if let body = style.link.body {
                body(context)
            } else {
                MDLinkView(style: style, url: context.url, title: context.title)
            }
        case .image(let context):
            if let body = style.image.body {
                body(context)
            } else {
                MDImageView(
                    style: style,
                    url: context.url,
                    title: context.title
                )
            }
        case .table(let context):
            if let body = style.table.body {
                body(context)
            } else {
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
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var renderMiscBlock: some View {
        switch item.block {
        case .footnote(let context):
            if let body = style.footnote.body {
                body(context)
            } else {
                MDFootnoteView(
                    style: style,
                    label: context.label,
                    content: context.content
                )
            }
        case .mathInline(let context):
            if let body = style.mathInline.body {
                body(MDParser.decodeLatexTag(context.text))
            } else {
                MDMathView(
                    style: style,
                    isInline: true,
                    content: MDParser.decodeLatexTag(context.text)
                )
            }
        case .mathBlock(let context):
            if let body = style.mathBlock.body {
                body(MDParser.decodeLatexTag(context.text))
            } else {
                MDMathView(
                    style: style,
                    isInline: false,
                    content: MDParser.decodeLatexTag(context.text)
                )
            }
        default:
            EmptyView()
        }
    }
    
    private func headingStyle(for level: Int) -> MDTextDetailStyle {
        switch level {
        case 1: return style.header1
        case 2: return style.header2
        case 3: return style.header3
        case 4: return style.header4
        case 5: return style.header5
        default: return style.header6
        }
    }
}
