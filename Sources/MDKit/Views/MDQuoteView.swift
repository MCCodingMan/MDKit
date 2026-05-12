//
//  MDQuoteView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDQuoteView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        HStack(alignment: .top, spacing: style.quote.view.lineSpacing()) {
            quoteLineView(style.quote.line)
            VStack(alignment: .leading, spacing: style.quote.view.lineSpacing()) {
                ForEach(node.children, id: \.position) { quoteChildren in
                    MDBlockView(node: quoteChildren)
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
