//
//  Untitled.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDOrderListView: View {
    let style: MDStyle
    let items: [MDListItem]
    var body: some View {
        VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let number = item.depthPath.last ?? (index + 1)
                VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                    HStack(alignment: .top, spacing: style.orderedList.view.markerSpacing()) {
                        listMarkerView(
                            style: style.orderedList.marker,
                            context: MDListMarkerContext(
                                index: index,
                                checked: nil,
                                depthPath: item.depthPath
                            ),
                            defaultText: "\(number)."
                        )
                        if item.text.isEmpty == false {
                            MDTextView(
                                text: item.text,
                                textStyle: style.orderedList.text,
                                inlineTextStyle: style.inline
                            )
                        }
                    }
                    if item.blocks.isEmpty == false {
                        VStack(alignment: .leading, spacing: style.orderedList.view.itemSpacing()) {
                            ForEach(item.blocks, id: \.self) { block in
                                MDRenderer.makeBlockView(block: block)
                            }
                        }
                        .padding(.leading, style.orderedList.view.indent())
                    }
                }
                .padding(.leading, CGFloat(max(0, item.depthPath.count - 1)) * style.orderedList.view.indent())
            }
        }
    }
    
    
    @ViewBuilder
    private func listMarkerView(
        style: MDListStyle.MarkerStyle,
        context: MDListMarkerContext,
        defaultText: String
    ) -> some View {
        if let markerView = style.markerView {
            markerView(context)
        } else {
            Text(defaultText)
                .font(style.markerFont())
                .foregroundColor(style.markerColor())
        }
    }
}
