//
//  MDEqualView.swift
//  MDKit
//
//  Created by joker on 2026/2/5.
//

import SwiftUI

extension MDBlockView: Equatable {
    nonisolated static func == (lhs: MDBlockView, rhs: MDBlockView) -> Bool {
        lhs.item.block == rhs.item.block
    }
}

extension MDCachedAsyncImage: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url?.absoluteString == rhs.url?.absoluteString
    }
}

extension MDCodeView: Equatable {
    nonisolated static func == (lhs: MDCodeView, rhs: MDCodeView) -> Bool {
        lhs.code == rhs.code && lhs.language == rhs.language
    }
}

extension MDCodeView.CodeBlock: Equatable {
    nonisolated static func == (lhs: MDCodeView.CodeBlock, rhs: MDCodeView.CodeBlock) -> Bool {
        lhs.code == rhs.code && lhs.language == rhs.language
    }
}

extension MDCodeView.CodeLineView: Equatable {
    nonisolated static func == (lhs: MDCodeView.CodeLineView, rhs: MDCodeView.CodeLineView) -> Bool {
        lhs.line.isEqual(to: rhs.line)
    }
}

extension MDCodeView.LanguageHeader: Equatable {
    nonisolated static func == (lhs: MDCodeView.LanguageHeader, rhs: MDCodeView.LanguageHeader) -> Bool {
        lhs.language == rhs.language
    }
}

extension MDDividerView: Equatable {
    nonisolated static func == (lhs: MDDividerView, rhs: MDDividerView) -> Bool {
        true
    }
}

extension MDFootnoteView: Equatable {
    nonisolated static func == (lhs: MDFootnoteView, rhs: MDFootnoteView) -> Bool {
        lhs.label == rhs.label && lhs.content == rhs.content
    }
}

extension MDHTMLView: Equatable {
    nonisolated static func == (lhs: MDHTMLView, rhs: MDHTMLView) -> Bool {
        lhs.text == rhs.text
    }
}

extension HTMLTextView: Equatable {
    nonisolated static func == (lhs: HTMLTextView, rhs: HTMLTextView) -> Bool {
        lhs.attributed?.string == rhs.attributed?.string
    }
}

extension MDHeadingView: Equatable {
    nonisolated static func == (lhs: MDHeadingView, rhs: MDHeadingView) -> Bool {
        lhs.level == rhs.level && lhs.text == rhs.text
    }
}

extension MDImageView: Equatable {
    nonisolated static func == (lhs: MDImageView, rhs: MDImageView) -> Bool {
        lhs.url == rhs.url && lhs.title == rhs.title
    }
}

extension MDLinkView: Equatable {
    nonisolated static func == (lhs: MDLinkView, rhs: MDLinkView) -> Bool {
        lhs.url == rhs.url && lhs.title == rhs.title
    }
}

extension MDMathView: Equatable {
    nonisolated static func == (lhs: MDMathView, rhs: MDMathView) -> Bool {
        lhs.isInline == rhs.isInline && lhs.content == rhs.content
    }
}

extension MDOrderListView: Equatable {
    nonisolated static func == (lhs: MDOrderListView, rhs: MDOrderListView) -> Bool {
        lhs.items == rhs.items
    }
}

extension MDParagraphView: Equatable {
    nonisolated static func == (lhs: MDParagraphView, rhs: MDParagraphView) -> Bool {
        lhs.text == rhs.text
    }
}

extension MDQuoteView: Equatable {
    nonisolated static func == (lhs: MDQuoteView, rhs: MDQuoteView) -> Bool {
        lhs.lines == rhs.lines
    }
}

extension MDTableView: Equatable {
    nonisolated static func == (lhs: MDTableView, rhs: MDTableView) -> Bool {
        let lhsHeaders = lhs.headers.map(\.text)
        let rhsHeaders = rhs.headers.map(\.text)
        if lhsHeaders != rhsHeaders { return false }
        
        let lhsRows = lhs.rows.map { $0.map(\.text) }
        let rhsRows = rhs.rows.map { $0.map(\.text) }
        return lhsRows == rhsRows
    }
}

extension MDTableView.CellContent: Equatable {
    nonisolated static func == (lhs: MDTableView.CellContent, rhs: MDTableView.CellContent) -> Bool {
        lhs.isHeader == rhs.isHeader &&
        lhs.text == rhs.text &&
        lhs.columnIndex == rhs.columnIndex &&
        lhs.rowIndex == rhs.rowIndex &&
        lhs.isLast == rhs.isLast
    }
}

extension MDTaskListView: Equatable {
    nonisolated static func == (lhs: MDTaskListView, rhs: MDTaskListView) -> Bool {
        lhs.items == rhs.items
    }
}

extension MDTextView: Equatable {
    nonisolated static func == (lhs: MDTextView, rhs: MDTextView) -> Bool {
        lhs.text == rhs.text
    }
}

extension MDUnorderlListView: Equatable {
    nonisolated static func == (lhs: MDUnorderlListView, rhs: MDUnorderlListView) -> Bool {
        lhs.items == rhs.items
    }
}
