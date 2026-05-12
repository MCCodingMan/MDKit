//
//  MDUnOrderListItemView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/13.
//

import SwiftUI

struct MDUnOrderListItemView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        HStack(alignment: .top, spacing: style.unorderedList.view.markerSpacing()) {
            listMarkerView(
                style: style.unorderedList.marker,
                depth: listContent.1
            )
            VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                ForEach(node.children, id: \.position) { item in
                    MDBlockView(node: item)
                        .equatable()
                }
            }
        }
        .padding(.leading, listContent.1 == 0 ? 0 : style.unorderedList.view.indent())
    }
    
    @ViewBuilder
    private func listMarkerView(
        style: MDListStyle.MarkerStyle,
        depth: Int,
    ) -> some View {
        if let markerView = style.markerView {
            markerView(.init(index: listContent.0, checked: nil, depthPath: listContent.1))
        } else {
            let imageName = {
                switch depth % 3 {
                case 0:
                    return "circle.fill"
                case 1:
                    return "circle"
                case 2:
                    return "circle.fill"
                default:
                    return "circle.fill"
                }
            }()
            Image(systemName: imageName)
                .font(.system(size: style.markerFontSize() / 3.0))
                .foregroundColor(style.markerColor())
                .alignmentGuide(.top) { d in
                    d[.top] - style.markerFontSize() / 2.0
                }
        }
    }
    
    var listContent: (Int, Int) {
        if case let .listItem(_, index, depth) = node.content {
            return (index, depth)
        }
        return (0, 0)
    }
}
