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
        let code: String
        let language: String?
        let style: MDCodeStyle
        
        @State private var highlightedText: AttributedString?
        
        init(code: String, language: String?, style: MDCodeStyle) {
            self.code = code
            self.language = language
            self.style = style
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                Text(highlightedText ?? AttributedString(code))
                    .font(style.view.contentView.text.font())
                    .foregroundStyle(style.view.contentView.text.color())
                    .mdBranchView {
                        if let lineSpacing = style.view.contentView.text.lineSpacing {
                            $0.lineSpacing(lineSpacing())
                        } else {
                            $0
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .mdEdgePadding(style.view.contentView.padding())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(style.view.contentView.background())
            .task(id: code) {
                if let highlightedText, String(highlightedText.characters) == code {
                    return
                }
                if let highlightText = style.view.contentView.highlightCode {
                    let text = await highlightText(code, language)
                    self.highlightedText = AttributedString(text)
                } else {
                    self.highlightedText = AttributedString(code)
                }
            }
        }
    }
}
