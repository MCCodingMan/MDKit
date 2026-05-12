//
//  MDHeadingView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDHeadingView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        if let header {
            MDTextView(
                text: header.text,
                textStyle: headingStyle(for: header.level).text,
                inlineTextStyle: style.inline
            )
        }
    }
    
    var header: (level: Int, text: String)? {
        if case let .heading(level, content) = node.content {
            return (level, content)
        }
        return nil
    }
    
    func headingStyle(for level: Int) -> MDTextDetailStyle {
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
