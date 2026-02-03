//
//  MDUnorderlListView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDUnorderlListView: View {
    let style: MDStyle
    let items: [MDListItem]
    var body: some View {
        VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                    HStack(alignment: .top, spacing: style.unorderedList.view.markerSpacing()) {
                        listMarkerView(
                            style: style.unorderedList.marker,
                            context: MDListMarkerContext(
                                index: index,
                                checked: nil,
                                depthPath: item.depthPath
                            ),
                            defaultText: "•"
                        )
                        if item.text.isEmpty == false {
                            MDTextView(
                                text: item.text,
                                textStyle: style.unorderedList.text,
                                inlineTextStyle: style.inline
                            )
                        }
                    }
                    if item.blocks.isEmpty == false {
                        VStack(alignment: .leading, spacing: style.unorderedList.view.itemSpacing()) {
                            ForEach(item.blocks, id: \.self) { block in
                                MDRenderer.makeBlockView(block: block)
                            }
                        }
                        .padding(.leading, style.unorderedList.view.indent())
                    }
                }
                .padding(.leading, CGFloat(max(0, item.depthPath.count - 1)) * style.unorderedList.view.indent())
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
