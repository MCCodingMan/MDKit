//
//  MDUnorderlListView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDUnorderlListView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        LazyVStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
            ForEach(node.children, id: \.position) { item in
                MDBlockView(node: item)
                    .equatable()
            }
        }
    }
}
