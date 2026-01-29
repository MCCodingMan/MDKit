//
//  MDCodeBlockView.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

import SwiftUI

struct MDCodeBlockView: View {
    let code: String
    let language: String?
    let style: MDCodeStyle
    
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

    private var highlightedText: AttributedString {
        if let highlightText = style.view.contentView.highlightCode {
            return AttributedString(highlightText(code, language))
        }
        return AttributedString(code)
    }
}
