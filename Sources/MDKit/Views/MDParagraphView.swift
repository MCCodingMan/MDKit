//
//  MDParagraphView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDParagraphView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        MDTextView(
            text: text,
            textStyle: style.paragraph.text,
            inlineTextStyle: style.inline
        )
    }
    
    var text: String {
        if case let .text(text) = node.content {
            return text
        }
        return ""
    }
}
