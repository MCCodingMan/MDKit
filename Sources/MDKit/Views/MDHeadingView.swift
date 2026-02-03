//
//  MDHeadingView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDHeadingView: View {
    let style: MDStyle
    let level: Int
    let text: String
    var body: some View {
        MDTextView(
            text: text,
            textStyle: headingStyle.text,
            inlineTextStyle: style.inline
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    var headingStyle: MDTextDetailStyle {
        switch level {
        case 1: return style.header1
        case 2: return style.header2
        case 3: return style.header3
        case 4: return style.header4
        case 5: return style.header5
        default: return style.header6
        }
    }
}
