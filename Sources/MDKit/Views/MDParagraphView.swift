//
//  MDParagraphView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDParagraphView: View {
    let style: MDStyle
    let text: String
    var body: some View {
        MDTextView(
            text: text,
            textStyle: style.paragraph.text,
            inlineTextStyle: style.inline
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
