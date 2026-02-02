import Foundation
import Markdown

/// Markdown 解析器实现
public struct MDParser: MDParsing {
    public init() {}
    
    /// 解析 Markdown 文本为块级文档结构
    public func parse(markdown: String) -> MDDocument {
        MDDocument(blocks: parseBlocks(markdown: markdown))
    }
}

public final class MDCachedParser: MDParsing {
    nonisolated(unsafe) public static let shared = MDCachedParser()
    nonisolated(unsafe) private static var cachedMarkdown: String = ""
    nonisolated(unsafe) private static var cachedBlocks: [MDBlock] = []
    nonisolated(unsafe) private static var stablePrefixUTF16Count: Int = 0
    nonisolated(unsafe) private static var stablePrefixBlocks: [MDBlock] = []
    
    public init() {}
    
    public func parse(markdown: String) -> MDDocument {
        if markdown == MDCachedParser.cachedMarkdown {
            print("MDCachedParser: hit full cache")
            return MDDocument(blocks: MDCachedParser.cachedBlocks)
        }
        if MDCachedParser.cachedMarkdown.isEmpty {
            print("MDCachedParser: cold start full parse")
            return parseFull(markdown: markdown)
        }
        if markdown.hasPrefix(MDCachedParser.cachedMarkdown) {
            let appended = String(markdown.dropFirst(MDCachedParser.cachedMarkdown.count))
            if needsFullReparse(appended: appended) {
                print("MDCachedParser: appended requires full parse")
                return parseFull(markdown: markdown)
            }
            if MDCachedParser.stablePrefixUTF16Count == 0 || MDCachedParser.stablePrefixBlocks.isEmpty {
                print("MDCachedParser: missing stable prefix, full parse")
                return parseFull(markdown: markdown)
            }
            let totalUTF16 = markdown.utf16.count
            let startUTF16 = min(MDCachedParser.stablePrefixUTF16Count, totalUTF16)
            let startIndex = String.Index(utf16Offset: startUTF16, in: markdown)
            let suffix = String(markdown[startIndex...])
            let suffixBlocks = parseBlocks(markdown: suffix)
            let merged = MDCachedParser.stablePrefixBlocks + suffixBlocks
            MDCachedParser.cachedMarkdown = markdown
            MDCachedParser.cachedBlocks = merged
            updateStablePrefix(markdown: markdown, blocks: merged)
            print("MDCachedParser: reuse prefix cache, parse suffix")
            return MDDocument(blocks: merged)
        }
        print("MDCachedParser: content changed, full parse")
        return parseFull(markdown: markdown)
    }
    
    private func parseFull(markdown: String) -> MDDocument {
        let blocks = parseBlocks(markdown: markdown)
        MDCachedParser.cachedMarkdown = markdown
        MDCachedParser.cachedBlocks = blocks
        updateStablePrefix(markdown: markdown, blocks: blocks)
        return MDDocument(blocks: blocks)
    }
    
    private func updateStablePrefix(markdown: String, blocks: [MDBlock]) {
        let totalUTF16 = markdown.utf16.count
        let prefixUTF16 = min(MDKit.stablePrefixUTF16Count(in: markdown), totalUTF16)
        MDCachedParser.stablePrefixUTF16Count = prefixUTF16
        if prefixUTF16 == 0 {
            MDCachedParser.stablePrefixBlocks = []
            return
        }
        if prefixUTF16 == totalUTF16 {
            MDCachedParser.stablePrefixBlocks = blocks
            return
        }
        let endIndex = String.Index(utf16Offset: prefixUTF16, in: markdown)
        let prefix = String(markdown[..<endIndex])
        MDCachedParser.stablePrefixBlocks = parseBlocks(markdown: prefix)
    }
}

/// 将 Markdown AST 遍历为块级模型的访问器
private struct BlocksVisitor: MarkupVisitor {
    typealias Result = [MDBlock]
    var depthPath: [Int] = []
    
    /// 默认遍历逻辑，递归处理所有子节点
    mutating func defaultVisit(_ markup: Markup) -> [MDBlock] {
        var result: [MDBlock] = []
        for child in markup.children {
            result.append(contentsOf: visit(child))
        }
        return result
    }
    
    /// 处理标题节点
    mutating func visitHeading(_ heading: Heading) -> [MDBlock] {
        let headingText = inlineText(from: heading)
        return [.heading(level: heading.level, text: headingText)]
    }
    
    /// 处理段落节点
    mutating func visitParagraph(_ paragraph: Paragraph) -> [MDBlock] {
        blocks(from: paragraph)
    }
    
    /// 处理引用块，将标题与段落合并为行文本
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
    
    /// 处理无序列表，识别任务列表与普通列表
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
    
    /// 处理有序列表，识别任务列表与普通列表
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
    
    /// 处理代码块
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> [MDBlock] {
        let language = codeBlock.language ?? ""
        let code = codeBlock.code.trimmingCharacters(in: .newlines)
        return [.code(language: language.isEmpty ? nil : language, code: code)]
    }
    
    /// 处理分割线
    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> [MDBlock] {
        [.divider]
    }
    
    /// 处理 HTML 块
    mutating func visitHTMLBlock(_ htmlBlock: HTMLBlock) -> [MDBlock] {
        [.html(htmlBlock.rawHTML)]
    }
    
    /// 处理表格，规范表头与表体
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
    
    /// 处理图片
    mutating func visitImage(_ image: Image) -> [MDBlock] {
        [.image(alt: inlineText(from: image), url: image.source ?? "", title: image.title)]
    }
    
    /// 处理链接
    mutating func visitLink(_ link: Link) -> [MDBlock] {
        let title = inlineText(from: link)
        return [.link(title: title, url: link.destination ?? "")]
    }
}

/// 将 Markup 节点转换为块级列表
private func blocks(from markup: Markup, depthPath: [Int] = []) -> [MDBlock] {
    var visitor = BlocksVisitor(depthPath: depthPath)
    return markup.accept(&visitor)
}

private func parseBlocks(markdown: String) -> [MDBlock] {
    let processed = MDLatexParser.process(in: markdown)
    let document = Document(parsing: processed)
    let blocks = blocks(from: document)
    let frontBlocks = blocks.filter { block in
        switch block {
        case .footnote:
            return false
        default:
            return true
        }
    }
    let footnoteBlocks = blocks.filter { block in
        switch block {
        case .footnote:
            return true
        default:
            return false
        }
    }
    return frontBlocks + footnoteBlocks
}

/// 将段落拆分为块级元素，识别图像与公式
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
        let footnotes = footnoteDefinitions(from: text)
        if footnotes.isEmpty == false {
            blocks.append(contentsOf: footnotes)
            return
        }
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

/// 将内联节点展开为 Markdown 文本
/// - Parameter markup: 任意内联节点
/// - Returns: 与节点等价的 Markdown 字符串表示
private func inlineText(from markup: Markup) -> String {
    // 纯文本节点，直接返回其字符串内容
    if let text = markup as? Text {
        return text.string
    }
    // 斜体节点，递归拼接子节点并包裹 *
    if let emphasis = markup as? Emphasis {
        return "_" + emphasis.children.map { inlineText(from: $0) }.joined() + "_"
    }
    // 加粗节点，递归拼接子节点并包裹 **
    if let strong = markup as? Strong {
        return "**" + strong.children.map { inlineText(from: $0) }.joined() + "**"
    }
    // 删除线节点，递归拼接子节点并包裹 ~~
    if let strikethrough = markup as? Strikethrough {
        return "~~" + strikethrough.children.map { inlineText(from: $0) }.joined() + "~~"
    }
    // 行内代码，使用反引号包裹原始代码
    if let inlineCode = markup as? InlineCode {
        return "`" + inlineCode.code + "`"
    }
    // 硬换行，保留为换行符
    if markup is LineBreak {
        return "\n"
    }
    // 软换行，保留为换行符
    if markup is SoftBreak {
        return "\n"
    }
    // 链接节点，递归生成文本标签并拼接目标地址
    if let link = markup as? Link {
        let label = link.children.map { inlineText(from: $0) }.joined()
        return "[\(label)](\(link.destination ?? ""))"
    }
    // 图片节点，递归生成 alt 文本并拼接图片地址
    if let image = markup as? Image {
        let alt = image.children.map { inlineText(from: $0) }.joined()
        return "![\(alt)](\(image.source ?? ""))"
    }
    // 其他内联节点，递归展开其子节点并拼接
    return markup.children.map { inlineText(from: $0) }.joined()
}

/// 判断文本是否为数学内容，true 为块公式，false 为行内公式
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

private func footnoteDefinitions(from text: String) -> [MDBlock] {
    let lines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    guard lines.isEmpty == false else { return [] }
    var blocks: [MDBlock] = []
    var currentLabel: String?
    var contentLines: [String] = []
    
    func flush() {
        guard let label = currentLabel else { return }
        let content = contentLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        if label.isEmpty == false, content.isEmpty == false {
            blocks.append(.footnote(label: label, content: content))
        }
        currentLabel = nil
        contentLines = []
    }
    
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("[^"), let markerRange = trimmed.range(of: "]:") {
            flush()
            let labelRange = trimmed.index(trimmed.startIndex, offsetBy: 2)..<markerRange.lowerBound
            let label = String(trimmed[labelRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            let firstContent = String(trimmed[markerRange.upperBound...]).trimmingCharacters(in: .whitespaces)
            currentLabel = label
            if firstContent.isEmpty == false {
                contentLines.append(firstContent)
            }
            continue
        }
        if currentLabel != nil {
            if trimmed.isEmpty {
                contentLines.append("")
                continue
            }
            if line.hasPrefix("    ") || line.hasPrefix("\t") {
                contentLines.append(line.trimmingCharacters(in: .whitespaces))
                continue
            }
        }
        return []
    }
    flush()
    return blocks
}

/// 提取块级节点的文本内容
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

/// 列表项的解析结果
private struct ParsedListItem {
    let text: String
    let depthPath: [Int]
    let checked: Bool?
    let blocks: [MDBlock]
}

/// 收集无序列表项并保留嵌套路径
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

/// 收集有序列表项并保留嵌套路径
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

/// 提取列表项的文本与嵌套块内容
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

/// 读取任务列表的勾选状态
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

private func stablePrefixUTF16Count(in markdown: String) -> Int {
    let lines = markdown.split(separator: "\n", omittingEmptySubsequences: false)
    var inFencedCode = false
    var inMathBlock = false
    var offset = 0
    var lastBoundary = 0
    for (index, line) in lines.enumerated() {
        let lineText = String(line)
        let trimmed = lineText.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("```") || trimmed.hasPrefix("~~~") {
            inFencedCode.toggle()
        }
        if trimmed == "$$" {
            inMathBlock.toggle()
        }
        offset += lineText.utf16.count
        if index < lines.count - 1 {
            offset += 1
        }
        if trimmed.isEmpty, inFencedCode == false, inMathBlock == false {
            lastBoundary = offset
        }
    }
    return lastBoundary
}

private func needsFullReparse(appended: String) -> Bool {
    if appended.isEmpty {
        return false
    }
    let lines = appended.split(separator: "\n", omittingEmptySubsequences: false)
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("[^"), trimmed.contains("]:") {
            return true
        }
        if trimmed.hasPrefix("["), trimmed.contains("]:") {
            return true
        }
    }
    return false
}

/// 提取脚注定义并返回去除脚注后的正文
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
