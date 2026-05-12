//
//  MDMathView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI
import LaTeXSwiftUI

struct MDMathView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    
    var mathStyle: MDMathStyle {
        node.kind is MDMathInlineKind ? style.mathInline : style.mathBlock
    }
    
    var body: some View {
        if let mathContent {
            LaTeX(mathContent.decodeLatexTag())
                .font(mathStyle.text.font())
                .renderingStyle(.original)
                .renderingAnimation(.easeInOut)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id(mathContent)
        }
    }
    
    var mathContent: String? {
        if case let .text(content) = node.content {
            return content
        }
        return nil
    }
}
