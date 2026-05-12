//
//  MDOrderListItemView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/13.
//

import SwiftUI

struct MDOrderListItemView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        HStack(alignment: .top, spacing: style.orderedList.view.markerSpacing()) {
            listMarkerView(
                style: style.orderedList.marker,
                defaultText: "\(listContent.0)."
            )
            VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                ForEach(node.children, id: \.position) { item in
                    MDBlockView(node: item)
                        .equatable()
                }
            }
        }
        .padding(.leading, listContent.1 == 0 ? 0 : style.orderedList.view.indent())
    }
    
    @ViewBuilder
    private func listMarkerView(
        style: MDListStyle.MarkerStyle,
        defaultText: String
    ) -> some View {
        if let markerView = style.markerView {
            markerView(.init(index: listContent.0, checked: nil, depthPath: listContent.1))
        } else {
            Text(defaultText)
                .equatable()
                .font(.system(size: style.markerFontSize(), weight: style.markerFontWeight()))
                .foregroundColor(style.markerColor())
        }
    }
    
    var listContent: (Int, Int) {
        if case let .listItem(_, index, depth) = node.content {
            return (index, depth)
        }
        return (0, 0)
    }
}
