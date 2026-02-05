//
//  MDCodeView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDCodeView: View {
    let style: MDStyle
    let language: String?
    let code: String
    var body: some View {
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
                CodeBlock(code: code, language: language, style: style.code)
            }
        }
        .background(style.code.container.backgroundColor())
        .radiusBorder(style: style.code.container.border)
    }
}


extension MDCodeView {
    struct CodeBlock: View {
        let codeLines: [String]
        let language: String?
        let style: MDCodeStyle
        
        struct HighlightModel {
            var highlightCode: AttributedString
            var isHighlight: Bool = false
        }
        
        @State private var attCodeLines: [HighlightModel] = []
                
        init(code: String, language: String?, style: MDCodeStyle) {
            self.codeLines = code.components(separatedBy: "\n")
            self.language = language
            self.style = style
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(alignment: .leading, spacing: style.view.contentView.text.lineSpacing?() ?? 0) {
                    ForEach(Array(attCodeLines.enumerated()), id: \.offset) {_, code in
                        Text(code.highlightCode)
                            .font(style.view.contentView.text.font())
                            .foregroundStyle(style.view.contentView.text.color())
                            .frame(height: style.view.contentView.codeSingleHeight())
                    }
                }
                .mdEdgePadding(style.view.contentView.padding())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.view.contentView.background())
            .task(id: codeLines) {
                if let highlightHandler = style.view.contentView.highlightCode {
                    // 1. 同步行数，确保索引安全，并为新行提供初始值
                    if attCodeLines.count < codeLines.count {
                        for i in attCodeLines.count..<codeLines.count {
                            attCodeLines.append(.init(highlightCode: AttributedString(codeLines[i])))
                        }
                    } else if attCodeLines.count > codeLines.count {
                        attCodeLines = Array(attCodeLines.prefix(codeLines.count))
                    }
                    // 2. 遍历每一行进行高亮处理
                    for i in 0..<codeLines.count {
                        let line = codeLines[i]
                        
                        // 筛选逻辑：如果当前行内容匹配且已经高亮过，则跳过
                        if i < attCodeLines.count {
                            let current = attCodeLines[i]
                            let contentMatches = String(current.highlightCode.characters) == line && current.isHighlight
                            if contentMatches {
                                continue
                            }
                            // 执行高亮
                            let nsAtt = await highlightHandler(line, language)
                            attCodeLines[i].highlightCode = AttributedString(nsAtt)
                            attCodeLines[i].isHighlight = true
                        }
                    }
                } else {
                    if attCodeLines.count != codeLines.count {
                        attCodeLines = codeLines.map({ .init(highlightCode: AttributedString($0)) })
                    }
                    
                }
            }
        }
    }
}
