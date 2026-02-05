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
                LanguageHeader(language: language, style: style)
                    .equatable()
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

// MARK: - Language Header
extension MDCodeView {
    struct LanguageHeader: View {
        let language: String
        let style: MDStyle
        
        var body: some View {
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
    }
}

// MARK: - Code Block
extension MDCodeView {
    
    struct CodeBlock: View {
        let code: String
        let language: String?
        let style: MDCodeStyle
        
        @State private var codeLines: [CodeLine] = []
        @State private var isAppear = false
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: style.view.contentView.text.lineSpacing?() ?? 0) {
                    ForEach(codeLines) { codeLine in
                        CodeLineView(line: codeLine.content, style: style)
                    }
                }
                .mdEdgePadding(style.view.contentView.padding())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.view.contentView.background())
            .onChangeValue(code) { _, newCode in
                Task {
                    await updateLines(newCode, highlighted: true)
                }
            }
            .onFirstAppear {
                Task {
                    // 初始加载时显示纯文本
                    await updateLines(code, highlighted: true)
                }
            }
        }
        
        /// 更新代码行（支持高亮和纯文本）
        private func updateLines(_ text: String, highlighted: Bool) async {
            let attributedString: NSAttributedString
            
            if highlighted, let highlightHandler = style.view.contentView.highlightCode {
                // 执行语法高亮
                attributedString = await highlightHandler(text, language)
            } else {
                // 纯文本
                attributedString = NSAttributedString(string: text)
            }
            
            let splitLines = splitByNewline(of: attributedString)
            
            // 复用已有行的 ID，只更新内容
            var newLines: [CodeLine] = []
            for (index, content) in splitLines.enumerated() {
                if index < codeLines.count {
                    // 复用已有 ID（避免视图重建）
                    newLines.append(CodeLine(id: codeLines[index].id, content: content))
                } else {
                    // 新增行使用新 ID
                    newLines.append(CodeLine(content: content))
                }
            }
            
            codeLines = newLines
        }
        
        /// 按 "\n" 分割为多个 AttributedString（保留空行，不包含换行符本身）
        func splitByNewline(of attString: NSAttributedString) -> [NSAttributedString] {
            let text = attString.string
            var results: [NSAttributedString] = []
            var lineStart = 0
            
            for (i, char) in text.enumerated() {
                if char == "\n" {
                    // 截取当前行（不含 \n）
                    let range = NSRange(location: lineStart, length: i - lineStart)
                    results.append(attString.attributedSubstring(from: range))
                    lineStart = i + 1
                }
            }
            
            // 处理最后一行
            let range = NSRange(location: lineStart, length: text.count - lineStart)
            results.append(attString.attributedSubstring(from: range))
            
            return results
        }
    }
    
    // MARK: - Code Line Model
    struct CodeLine: Identifiable {
        let id: UUID
        let content: NSAttributedString
        
        init(id: UUID = UUID(), content: NSAttributedString) {
            self.id = id
            self.content = content
        }
    }
    
    // MARK: - Code Line View
    struct CodeLineView: View {
        let line: NSAttributedString
        let style: MDCodeStyle
        
        var body: some View {
            Text(AttributedString(line))
                .font(style.view.contentView.text.font())
                .foregroundStyle(style.view.contentView.text.color())
                .frame(height: style.view.contentView.codeSingleHeight())
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}
