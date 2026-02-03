//
//  MDMathView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI
import LaTeXSwiftUI

struct MDMathView: View {
    let style: MDStyle
    let isInline: Bool
    let content: String
    
    var mathStyle: MDMathStyle {
        isInline ? style.mathInline : style.mathBlock
    }
    
    var body: some View {
        LaTeX(content)
            .font(mathStyle.text.font())
            .renderingStyle(.original)
            .renderingAnimation(.easeInOut)
            .frame(maxWidth: .infinity, alignment: .leading)
            .id(content)
    }
}
