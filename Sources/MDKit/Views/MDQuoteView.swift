//
//  MDQuoteView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDQuoteView: View {
    let style: MDStyle
    let lines: [String]
    var body: some View {
        HStack(alignment: .top, spacing: style.quote.view.lineSpacing()) {
            quoteLineView(style.quote.line)
            VStack(alignment: .leading, spacing: style.quote.view.lineSpacing()) {
                ForEach(lines.indices, id: \.self) { index in
                    MDTextView(
                        text: lines[index],
                        textStyle: style.quote.text,
                        inlineTextStyle: style.inline
                    )
                }
            }
            Spacer(minLength: 0)
        }
        .mdEdgePadding(style.quote.view.padding())
        .background(style.quote.view.backgroundColor())
        .radiusBorder(style: style.quote.view.border)
    }
    
    
    @ViewBuilder
    private func quoteLineView(_ style: MDQuoteStyle.LineStyle) -> some View {
        if let lineView = style.lineView {
            lineView()
        } else {
            Rectangle()
                .fill(style.color())
                .frame(width: style.width())
        }
    }
}
