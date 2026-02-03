//
//  MDLinkView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDLinkView: View {
    let style: MDStyle
    let url: String
    let title: String
    var body: some View {
        Link(title, destination: URL(string: url) ?? URL(string: "about:blank")!)
            .font(style.link.text.font())
            .foregroundColor(style.link.text.color())
    }
}
