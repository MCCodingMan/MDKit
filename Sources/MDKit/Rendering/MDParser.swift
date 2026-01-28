import Foundation
import Markdown

public struct MDParser: MDParsing {
    public init() {}
    
    public func parse(markdown: String) -> MDDocument {
        let processed = MDLatexParser.process(in: markdown)
        let extraction = extractFootnotes(from: processed)
        let document = Document(parsing: extraction.markdown)
        let parsedBlocks = blocks(from: document) + extraction.footnotes
        return MDDocument(blocks: parsedBlocks)
    }
}

private struct BlocksVisitor: MarkupVisitor {
    typealias Result = [MDBlock]
    var depthPath: [Int] = []
    
    mutating func defaultVisit(_ markup: Markup) -> [MDBlock] {
        var result: [MDBlock] = []
        for child in markup.children {
            result.append(contentsOf: visit(child))
        }
        return result
    }
    
    mutating func visitHeading(_ heading: Heading) -> [MDBlock] {
        [.heading(level: heading.level, text: inlineText(from: heading))]
    }
    
    mutating func visitParagraph(_ paragraph: Paragraph) -> [MDBlock] {
        blocks(from: paragraph)
    }
    
    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> [MDBlock] {
        var lines: [String] = []
        for child in blockQuote.children {
            for block in visit(child) {
                switch block {
                case let .paragraph(text):
                    lines.append(text)
                case let .heading(_, text):
                    lines.append(text)
                default:
                    break
                }
            }
        }
        return lines.isEmpty ? [] : [.quote(lines: lines)]
    }
    
    mutating func visitUnorderedList(_ unorderedList: UnorderedList) -> [MDBlock] {
        let parsed = collectUnorderedItems(from: unorderedList, depthPath: depthPath)
        let hasCheckbox = parsed.contains { $0.checked != nil }
        if hasCheckbox {
            let taskItems = parsed.map { item in
                MDTaskItem(checked: item.checked ?? false, text: item.text, depthPath: item.depthPath, blocks: item.blocks)
            }
            return taskItems.isEmpty ? [] : [.taskList(items: taskItems)]
        }
        let listItems = parsed.map { MDListItem(text: $0.text, depthPath: $0.depthPath, blocks: $0.blocks) }
        return listItems.isEmpty ? [] : [.unorderedList(items: listItems)]
    }
    
    mutating func visitOrderedList(_ orderedList: OrderedList) -> [MDBlock] {
        let parsed = collectOrderedItems(from: orderedList, depthPath: depthPath)
        let hasCheckbox = parsed.contains { $0.checked != nil }
        if hasCheckbox {
            let taskItems = parsed.map { item in
                MDTaskItem(checked: item.checked ?? false, text: item.text, depthPath: item.depthPath, blocks: item.blocks)
            }
            return taskItems.isEmpty ? [] : [.taskList(items: taskItems)]
        }
        let listItems = parsed.map { MDListItem(text: $0.text, depthPath: $0.depthPath, blocks: $0.blocks) }
        return listItems.isEmpty ? [] : [.orderedList(items: listItems)]
    }
    
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> [MDBlock] {
        let language = codeBlock.language ?? ""
        let code = codeBlock.code.trimmingCharacters(in: .newlines)
        return [.code(language: language.isEmpty ? nil : language, code: code)]
    }
    
    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> [MDBlock] {
        [.divider]
    }
    
    mutating func visitHTMLBlock(_ htmlBlock: HTMLBlock) -> [MDBlock] {
        [.html(htmlBlock.rawHTML)]
    }
    
    mutating func visitTable(_ table: Table) -> [MDBlock] {
        var rows = Array(table.body.rows).map { row in
            Array(row.cells).map { inlineText(from: $0) }
        }
        var headerCells = Array(table.head.cells).map { inlineText(from: $0) }
        if headerCells.isEmpty, let firstRow = rows.first {
            headerCells = firstRow
            rows.removeFirst()
        } else if let firstRow = rows.first, firstRow == headerCells {
            rows.removeFirst()
        }
        return [.table(headers: headerCells, rows: rows)]
    }
    
    mutating func visitImage(_ image: Image) -> [MDBlock] {
        [.image(alt: inlineText(from: image), url: image.source ?? "", title: image.title)]
    }
    
    mutating func visitLink(_ link: Link) -> [MDBlock] {
        let title = inlineText(from: link)
        return [.link(title: title, url: link.destination ?? "")]
    }
}

private func blocks(from markup: Markup, depthPath: [Int] = []) -> [MDBlock] {
    var visitor = BlocksVisitor(depthPath: depthPath)
    return markup.accept(&visitor)
}

private func blocks(from paragraph: Paragraph) -> [MDBlock] {
    let children = Array(paragraph.children)
    var blocks: [MDBlock] = []
    var buffer: [Markup] = []
    
    func flushBuffer() {
        guard buffer.isEmpty == false else { return }
        let text = buffer.map { inlineText(from: $0) }.joined()
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        buffer.removeAll()
        guard trimmed.isEmpty == false else { return }
        if let math = mathContent(from: text) {
            if math {
                blocks.append(.mathBlock(text))
            } else {
                blocks.append(.mathInline(text))
            }
            return
        }
        blocks.append(.paragraph(text: text))
    }
    
    for child in children {
        if let image = child as? Image {
            flushBuffer()
            blocks.append(.image(alt: inlineText(from: image), url: image.source ?? "", title: image.title))
        } else {
            buffer.append(child)
        }
    }
    flushBuffer()
    return blocks
}

private func inlineText(from markup: Markup) -> String {
    if let text = markup as? Text {
        return text.string
    }
    if let emphasis = markup as? Emphasis {
        return "*" + emphasis.children.map { inlineText(from: $0) }.joined() + "*"
    }
    if let strong = markup as? Strong {
        return "**" + strong.children.map { inlineText(from: $0) }.joined() + "**"
    }
    if let strikethrough = markup as? Strikethrough {
        return "~~" + strikethrough.children.map { inlineText(from: $0) }.joined() + "~~"
    }
    if let inlineCode = markup as? InlineCode {
        return "`" + inlineCode.code + "`"
    }
    if markup is LineBreak {
        return "\n"
    }
    if markup is SoftBreak {
        return "\n"
    }
    if let link = markup as? Link {
        let label = link.children.map { inlineText(from: $0) }.joined()
        return "[\(label)](\(link.destination ?? ""))"
    }
    if let image = markup as? Image {
        let alt = image.children.map { inlineText(from: $0) }.joined()
        return "![\(alt)](\(image.source ?? ""))"
    }
    return markup.children.map { inlineText(from: $0) }.joined()
}

private func mathContent(from text: String) -> Bool? {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.hasPrefix("\\["), trimmed.hasSuffix("\\]") {
        let start = trimmed.index(trimmed.startIndex, offsetBy: 2)
        let end = trimmed.index(before: trimmed.endIndex)
        let content = trimmed[start..<end].trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty == false {
            return true
        }
    }
    if trimmed.hasPrefix("\\("), trimmed.hasSuffix("\\)") {
        let start = trimmed.index(trimmed.startIndex, offsetBy: 2)
        let end = trimmed.index(before: trimmed.endIndex)
        let content = trimmed[start..<end].trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty == false {
            return false
        }
    }
    if let start = trimmed.range(of: "$$") {
        if let end = trimmed.range(of: "$$", range: start.upperBound..<trimmed.endIndex) {
            let content = trimmed[start.upperBound..<end.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            if content.isEmpty == false {
                return true
            }
        }
    }
    if let s = trimmed.range(of: "\\(") {
        if let e = trimmed.range(of: "\\)", range: s.upperBound..<trimmed.endIndex) {
            let content = trimmed[s.upperBound..<e.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            if content.isEmpty == false {
                return false
            }
        }
    }
    if let s = trimmed.range(of: "\\[") {
        if let e = trimmed.range(of: "\\]", range: s.upperBound..<trimmed.endIndex) {
            let content = trimmed[s.upperBound..<e.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            if content.isEmpty == false {
                return true
            }
        }
    }
    var index = trimmed.startIndex
    while index < trimmed.endIndex {
        if trimmed[index] == "$" {
            let nextIndex = trimmed.index(after: index)
            if nextIndex < trimmed.endIndex, trimmed[nextIndex] == "$" {
                index = trimmed.index(after: nextIndex)
                continue
            }
            if let closing = trimmed[nextIndex...].firstIndex(of: "$") {
                let content = trimmed[nextIndex..<closing].trimmingCharacters(in: .whitespacesAndNewlines)
                if content.isEmpty == false {
                    return false
                }
            }
        }
        index = trimmed.index(after: index)
    }
    return nil
}

private func blockText(from markup: Markup) -> String {
    if let paragraph = markup as? Paragraph {
        return inlineText(from: paragraph)
    }
    if let heading = markup as? Heading {
        return inlineText(from: heading)
    }
    if let codeBlock = markup as? CodeBlock {
        return codeBlock.code
    }
    let text = markup.children.map { blockText(from: $0) }.joined(separator: "\n")
    return text.trimmingCharacters(in: .whitespacesAndNewlines)
}

private struct ParsedListItem {
    let text: String
    let depthPath: [Int]
    let checked: Bool?
    let blocks: [MDBlock]
}

private func collectUnorderedItems(from list: UnorderedList, depthPath: [Int]) -> [ParsedListItem] {
    var result: [ParsedListItem] = []
    let items = list.children.compactMap { $0 as? ListItem }
    for (index, item) in items.enumerated() {
        let itemPath = depthPath + [index + 1]
        let content = listItemContent(from: item, depthPath: itemPath)
        let checked = checkboxValue(from: item)
        result.append(ParsedListItem(text: content.text, depthPath: itemPath, checked: checked, blocks: content.blocks))
    }
    return result
}

private func collectOrderedItems(from list: OrderedList, depthPath: [Int]) -> [ParsedListItem] {
    var result: [ParsedListItem] = []
    let items = list.children.compactMap { $0 as? ListItem }
    for (index, item) in items.enumerated() {
        let itemPath = depthPath + [index + 1]
        let content = listItemContent(from: item, depthPath: itemPath)
        let checked = checkboxValue(from: item)
        result.append(ParsedListItem(text: content.text, depthPath: itemPath, checked: checked, blocks: content.blocks))
    }
    return result
}

private func listItemContent(from item: ListItem, depthPath: [Int]) -> (text: String, blocks: [MDBlock]) {
    var textParts: [String] = []
    var nestedBlocks: [MDBlock] = []
    for child in item.children {
        if child is Paragraph || child is Heading {
            let text = blockText(from: child)
            if text.isEmpty == false {
                textParts.append(text)
            }
            continue
        }
        if child is UnorderedList || child is OrderedList {
            nestedBlocks.append(contentsOf: blocks(from: child, depthPath: depthPath))
            continue
        }
        nestedBlocks.append(contentsOf: blocks(from: child, depthPath: depthPath))
    }
    let text = textParts.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    return (text, nestedBlocks)
}

private func checkboxValue(from item: ListItem) -> Bool? {
    switch item.checkbox {
    case .checked:
        return true
    case .unchecked:
        return false
    case .none:
        return nil
    }
}

private func extractFootnotes(from markdown: String) -> (markdown: String, footnotes: [MDBlock]) {
    let lines = markdown.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    var output: [String] = []
    var footnotes: [MDBlock] = []
    var index = 0
    
    while index < lines.count {
        let line = lines[index]
        if line.hasPrefix("[^"), let markerRange = line.range(of: "]:") {
            let labelRange = line.index(line.startIndex, offsetBy: 2)..<markerRange.lowerBound
            let label = String(line[labelRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            let contentStart = markerRange.upperBound
            let firstContent = String(line[contentStart...]).trimmingCharacters(in: .whitespaces)
            var contentLines: [String] = []
            if firstContent.isEmpty == false {
                contentLines.append(firstContent)
            }
            index += 1
            while index < lines.count {
                let next = lines[index]
                if next.trimmingCharacters(in: .whitespaces).isEmpty {
                    contentLines.append("")
                    index += 1
                    continue
                }
                if next.hasPrefix("    ") || next.hasPrefix("\t") {
                    let trimmed = next.trimmingCharacters(in: .whitespaces)
                    contentLines.append(trimmed)
                    index += 1
                    continue
                }
                break
            }
            let content = contentLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            if label.isEmpty == false, content.isEmpty == false {
                footnotes.append(.footnote(label: label, content: content))
            }
            continue
        }
        output.append(line)
        index += 1
    }
    return (output.joined(separator: "\n"), footnotes)
}
