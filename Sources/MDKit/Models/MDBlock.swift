import SwiftUI

public enum MDBlock: Hashable {
    case heading(level: Int, text: String)
    case paragraph(text: String)
    case quote(lines: [String])
    case unorderedList(items: [MDListItem])
    case orderedList(items: [MDListItem])
    case taskList(items: [MDTaskItem])
    case code(language: String?, code: String)
    case link(title: String, url: String)
    case image(alt: String, url: String, title: String?)
    case table(headers: [String], rows: [[String]])
    case divider
    case html(String)
    case footnote(label: String, content: String)
    case mathInline(String)
    case mathBlock(String)
    case mermaid(String)

    public static func == (lhs: MDBlock, rhs: MDBlock) -> Bool {
        switch (lhs, rhs) {
        case let (.heading(lLevel, lText), .heading(rLevel, rText)):
            return lLevel == rLevel && lText == rText
        case let (.paragraph(lText), .paragraph(rText)):
            return lText == rText
        case let (.quote(lLines), .quote(rLines)):
            return lLines == rLines
        case let (.unorderedList(lItems), .unorderedList(rItems)):
            return lItems == rItems
        case let (.orderedList(lItems), .orderedList(rItems)):
            return lItems == rItems
        case let (.taskList(lItems), .taskList(rItems)):
            return lItems == rItems
        case let (.code(lLang, lCode), .code(rLang, rCode)):
            return lLang == rLang && lCode == rCode
        case let (.link(lTitle, lUrl), .link(rTitle, rUrl)):
            return lTitle == rTitle && lUrl == rUrl
        case let (.image(lAlt, lUrl, lTitle), .image(rAlt, rUrl, rTitle)):
            return lAlt == rAlt && lUrl == rUrl && lTitle == rTitle
        case let (.table(lHeaders, lRows), .table(rHeaders, rRows)):
            return lHeaders == rHeaders && lRows == rRows
        case (.divider, .divider):
            return true
        case let (.html(lHtml), .html(rHtml)):
            return lHtml == rHtml
        case let (.footnote(lLabel, lContent), .footnote(rLabel, rContent)):
            return lLabel == rLabel && lContent == rContent
        case let (.mathInline(lContent), .mathInline(rContent)):
            return lContent == rContent
        case let (.mathBlock(lContent), .mathBlock(rContent)):
            return lContent == rContent
        case let (.mermaid(lContent), .mermaid(rContent)):
            return lContent == rContent
        default:
            return false
        }
    }
}

public struct MDListItem: Hashable {
    public let text: String
    public let depthPath: [Int]
    public let blocks: [MDBlock]

    public init(text: String, depthPath: [Int], blocks: [MDBlock] = []) {
        self.text = text
        self.depthPath = depthPath
        self.blocks = blocks
    }
}

public struct MDTaskItem: Hashable {
    public let checked: Bool
    public let text: String
    public let depthPath: [Int]
    public let blocks: [MDBlock]

    public init(checked: Bool, text: String, depthPath: [Int], blocks: [MDBlock] = []) {
        self.checked = checked
        self.text = text
        self.depthPath = depthPath
        self.blocks = blocks
    }
}
