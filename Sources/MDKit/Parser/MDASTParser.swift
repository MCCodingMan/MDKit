import Foundation
import Markdown

struct MDASTParser {
    private init() { }
    static func parse(_ content: String, options: ParseOptions = []) -> [MDASTNode] {
        var parser = MDASTParser()
        let processed = MDLatexParser.process(in: content)
        let document = Document(parsing: processed, options: options)
        return parser.visit(document).children
    }
    
    static func parse(text: String, source: URL? = nil, options: ParseOptions = []) -> [MDASTNode] {
        let document = Document(parsing: text, source: source, options: options)
        var parser = MDASTParser()
        return parser.visit(document).children
    }
}

extension MDASTParser: MarkupVisitor {
    typealias Result = MDASTNode
    
    mutating func defaultVisit(_ markup: any Markdown.Markup) -> MDASTNode {
        makeNode(kind: MDUnknownKind(), children: markup.children)
    }
    
    mutating func visitDocument(_ document: Document) -> MDASTNode {
        makeNode(kind: MDDocumentKind(), children: document.children)
    }
    
    mutating func visitHeading(_ heading: Heading) -> MDASTNode {
        MDASTNode(
            kind: MDHeadingKind(),
            children: [],
            content: .heading(level: heading.level, content: heading.plainText.decodeLatexTag())
        )
    }
    
    mutating func visitText(_ text: Text) -> MDASTNode {
        MDASTNode(
            kind: MDParagraphKind(),
            children: [],
            content: .text(text.plainText.decodeLatexTag())
        )
    }
    
    mutating func visitParagraph(_ paragraph: Paragraph) -> MDASTNode {
        if let math = paragraph.plainText.isMathString() {
            if math {
                MDASTNode(
                    kind: MDMathBlockKind(),
                    children: [],
                    content: .text(paragraph.plainText.decodeLatexTag())
                )
            } else {
                MDASTNode(
                    kind: MDMathInlineKind(),
                    children: [],
                    content: .text(paragraph.plainText.decodeLatexTag())
                )
            }
        } else {
            MDASTNode(
                kind: MDParagraphKind(),
                children: [],
                content: .text(paragraph.plainText.decodeLatexTag())
            )
            
        }
        
    }
    
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> MDASTNode {
        makeNode(kind: MDBlockQuoteKind(), children: blockQuote.children)
    }
    
    mutating func visitLink(_ link: Link) -> MDASTNode {
        guard let destination = link.destination else {
            return MDASTNode(
                kind: MDLinkKind(),
                children: [],
                content: .text(plainText(from: link).decodeLatexTag())
            )
        }
        let title = link.title ?? plainText(from: link)
        return makeNode(
            kind: MDLinkKind(),
            children: link.children,
            content: .link(title: title.decodeLatexTag(), destination: destination.decodeLatexTag())
        )
    }
    
    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> MDASTNode {
        MDASTNode(kind: MDDividerKind(), children: [], content: nil)
    }
    
    mutating func visitLineBreak(_ lineBreak: LineBreak) -> MDASTNode {
        MDASTNode(kind: MDHardBreakKind(), children: [], content: nil)
    }
    
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> MDASTNode {
        MDASTNode(kind: MDSoftBreakKind(), children: [], content: nil)
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> MDASTNode {
        MDASTNode(
            kind: MDCodeBlockKind(),
            children: [],
            content: .code(language: (codeBlock.language ?? "").decodeLatexTag(), code: codeBlock.code.decodeLatexTag())
        )
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> MDASTNode {
        let hasTask = unorderedList.children.contains { element in
            guard let item = element as? ListItem else { return false }
            return item.checkbox != .none
        }
        let kind: MDASTKind = hasTask ? MDTaskListKind() : MDUnorderedListKind()
        return makeNode(kind: kind, children: unorderedList.children)
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> MDASTNode {
        let hasTask = orderedList.children.contains { element in
            guard let item = element as? ListItem else { return false }
            return item.checkbox != .none
        }
        let kind: MDASTKind = hasTask ? MDTaskListKind() : MDOrderedListKind()
        return makeNode(kind: kind, children: orderedList.children, listStartIndex: Int(orderedList.startIndex))
    }
    
    mutating func visitListItem(_ listItem: ListItem) -> MDASTNode {
        switch listItem.checkbox {
        case .checked:
            makeNode(kind: MDTaskListItemKind(), children: listItem.children, content: .listItem(checked: true, index: 0, depth: listItem.listDepth))
        case .unchecked:
            makeNode(kind: MDTaskListItemKind(), children: listItem.children, content: .listItem(checked: false, index: 0, depth: listItem.listDepth))
        case .none:
            if listItem.parent is OrderedList {
                makeNode(kind: MDOrderedListItemKind(), children: listItem.children, content: .listItem(checked: nil, index: 0, depth: listItem.listDepth))
            } else if listItem.parent is UnorderedList {
                makeNode(kind: MDUnorderedListItemKind(), children: listItem.children, content: .listItem(checked: nil, index: 0, depth: listItem.listDepth))
            } else {
//                MDASTNode(kind: .unknown, children: [])
                fatalError("ListItem 解析到未知的节点")
            }
        }
    }
    
    mutating func visitImage(_ image: Image) -> MDASTNode {
        guard let source = image.source else {
            return MDASTNode(
                kind: MDParagraphKind(),
                children: [],
                content: .text(plainText(from: image).decodeLatexTag())
            )
        }
        let title = image.title ?? plainText(from: image)
        return makeNode(
            kind: MDImageKind(),
            children: image.children,
            content: .image(title: title.decodeLatexTag(), source: source.decodeLatexTag())
        )
    }
    
    mutating func visitHTMLBlock(_ htmlBlock: HTMLBlock) -> MDASTNode {
        MDASTNode(
            kind: MDHTMLKind(),
            children: [],
            content: .html(htmlBlock.rawHTML.decodeLatexTag())
        )
    }
    
    mutating func visitTable(_ table: Table) -> MDASTNode {
        MDASTNode(
            kind: MDTableKind(),
            children: [],
            content: tableContent(from: table)
        )
    }
    
    
    private mutating func makeNode(
        kind: MDASTKind,
        children: MarkupChildren,
        content: MDASTNode.Content? = nil,
        listStartIndex: Int? = nil,
    ) -> MDASTNode {
        let listIndexBase = listStartIndex ?? 0
        let nodes = children.enumerated().map { offset, element in
            var node = visit(element)
            node.position = offset
            if case let .listItem(checked, _, depth) = node.content {
                node.content = .listItem(checked: checked, index: offset + listIndexBase, depth: depth)
            }
            return node
        }
        return MDASTNode(
            kind: kind,
            children: nodes,
            content: content
        )
    }
    
    private func plainText(from markup: any Markdown.Markup) -> String {
        if let text = markup as? Text {
            return text.plainText
        }
        if let inlineCode = markup as? InlineCode {
            return inlineCode.code
        }
        if markup is LineBreak || markup is SoftBreak {
            return "\n"
        }
        if let link = markup as? Link {
            return link.children.map { plainText(from: $0) }.joined()
        }
        if let image = markup as? Image {
            return image.children.map { plainText(from: $0) }.joined()
        }
        return markup.children.map { plainText(from: $0) }.joined()
    }
    
    private func tableContent(from table: Table) -> MDASTNode.Content {
        var rows = Array(table.body.rows).map { row in
            Array(row.cells).map { plainText(from: $0).decodeLatexTag() }
        }
        var headers = Array(table.head.cells).map { plainText(from: $0).decodeLatexTag() }
        if headers.isEmpty, let firstRow = rows.first {
            headers = firstRow
            rows.removeFirst()
        } else if let firstRow = rows.first, firstRow == headers {
            rows.removeFirst()
        }
        return .table(headers: headers, rows: rows)
    }
    
    
}

extension ListItem {
    var listDepth: Int {
        var index = -1
        
        var currentElement = parent
        
        while currentElement != nil {
            if currentElement is ListItemContainer {
                index += 1
            }
            
            currentElement = currentElement?.parent
        }
        
        return index
    }
}
