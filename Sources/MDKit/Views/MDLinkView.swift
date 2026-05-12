//
//  MDLinkView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDLinkView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        if let linkContent {
            Link(linkContent.title, destination: URL(string: linkContent.destination) ?? URL(string: "about:blank")!)
                .font(style.link.text.font())
                .foregroundColor(style.link.text.color())
        }
    }
    
    
    var linkContent: (title: String, destination: String)? {
        if case let .link(title, destination) = node.content {
            let resolvedTitle = title ?? destination ?? ""
            return (resolvedTitle, destination ?? "")
        }
        return nil
    }
}
