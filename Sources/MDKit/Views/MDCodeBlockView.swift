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
        let style: MDCodeStyle
        
        private let highlightedText: AttributedString
        
        init(code: String, language: String?, style: MDCodeStyle) {
            self.code = code
            self.style = style
            self.highlightedText = {
                if let highlightText = style.view.contentView.highlightCode {
                    return AttributedString(highlightText(code, language))
                }
                return AttributedString(code)
            }()
        }
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: true) {
                Text(highlightedText)
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
        }
        
//        private var highlightedText: AttributedString {
//            if let highlightText = style.view.contentView.highlightCode {
//                return AttributedString(highlightText(code, language))
//            }
//            return AttributedString(code)
//        }
    }
}
