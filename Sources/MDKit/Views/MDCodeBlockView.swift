//
//  MDCodeView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDCodeView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    
    var body: some View {
        if let codeContent {
            VStack(alignment: .leading, spacing: 0) {
                LanguageHeader(language: codeContent.0, style: style)
                    .equatable()
                if let contentView = style.code.view.contentView.view {
                    contentView(codeContent.1, codeContent.0)
                } else {
                    CodeBlock(code: codeContent.1, language: codeContent.0, style: style.code)
                }
            }
            .background(style.code.container.backgroundColor())
            .radiusBorder(style: style.code.container.border)
        }
    }
    
    var codeContent: (String?, String)? {
        if case let .code(language, code) = node.content {
            return (language, code)
        }
        return nil
    }
}

// MARK: - Language Header
extension MDCodeView {
    struct LanguageHeader: View {
        let language: String?
        let style: MDStyle
        
        var body: some View {
            if let languageView = style.code.view.languageView.view {
                languageView(language)
            } else {
                HStack(spacing: 0) {
                    Text(language ?? "")
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
        let lineCount: Int
        
        @State private var codeLines: [CodeLine] = []
        
        init(code: String, language: String?, style: MDCodeStyle) {
            self.code = code
            self.language = language
            self.style = style
            self.lineCount = code.components(separatedBy: "\n").count
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(codeLines) { codeLine in
                        CodeLineView(line: codeLine.content, style: style)
                    }
                    Spacer(minLength: 0)
                }
                .frame(height: CGFloat(max(1, lineCount)) * style.view.contentView.codeSingleHeight()
                )
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
                attributedString = NSAttributedString(string: text, attributes: [.foregroundColor: style.view.contentView.codeColor(), .font: UIFont.monospacedSystemFont(ofSize: style.view.contentView.textFontSize(), weight: .regular)])
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
            await MainActor.run {
                codeLines = newLines
            }
        }
        
        /// 按 "\n" 分割为多个 AttributedString（保留空行，不包含换行符本身）
        func splitByNewline(of attString: NSAttributedString) -> [NSAttributedString] {
            var result: [NSAttributedString] = []
            let separator = "\n"
            let separatedStrings = attString.string.components(separatedBy: separator)
            
            // 跟踪当前偏移
            var currentLocation = 0
            
            for substring in separatedStrings {
                let length = (substring as NSString).length
                let range = NSRange(location: currentLocation, length: length)
                
                // 提取子 NSAttributedString，即使长度为 0 也添加
                var attributedLine = attString.attributedSubstring(from: range)
                var mutableAttributedLine = NSMutableAttributedString(attributedString: attributedLine)
                if length > 0 {
                    mutableAttributedLine.addAttribute(
                        .font,
                        value: UIFont.monospacedSystemFont(
                            ofSize: style.view.contentView.textFontSize(),
                            weight: .regular),
                        range: NSMakeRange(0, length))
                }
                result.append(attributedLine)
                
                // 更新位置，跳过分隔符
                currentLocation += length + (separator as NSString).length
            }
            return result
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
                .lineLimit(1)
                .frame(height: style.view.contentView.codeSingleHeight())
        }
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
