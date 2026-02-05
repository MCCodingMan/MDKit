//
//  MDFootnoteView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDFootnoteView: View {
    let style: MDStyle
    let label: String
    let content: String
    var body: some View {
        HStack(alignment: .top, spacing: style.footnote.viewStyle.spacing()) {
            Text("[\(label)]")
                .equatable()
                .font(style.footnote.textStyle.label.font())
                .foregroundColor(style.footnote.textStyle.label.color())
            MDTextView(
                text: content,
                textStyle: style.footnote.textStyle.content,
                inlineTextStyle: style.inline
            )
        }
    }
}
