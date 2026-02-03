//
//  MDTaskListView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDTaskListView: View {
    let style: MDStyle
    let items: [MDTaskItem]
    var body: some View {
        VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                    HStack(alignment: .top, spacing: style.taskList.view.markerSpacing()) {
                        taskMarkerView(
                            style: style.taskList.marker,
                            context: MDListMarkerContext(
                                index: index,
                                checked: item.checked,
                                depthPath: item.depthPath
                            ),
                            checked: item.checked
                        )
                        if item.text.isEmpty == false {
                            MDTextView(
                                text: item.text,
                                textStyle: style.taskList.text,
                                inlineTextStyle: style.inline
                            )
                        }
                    }
                    if item.blocks.isEmpty == false {
                        VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                            ForEach(item.blocks, id: \.self) { block in
                                MDRenderer.makeBlockView(block: block)
                            }
                        }
                        .padding(.leading, style.taskList.view.indent())
                    }
                }
                .padding(.leading, CGFloat(max(0, item.depthPath.count - 1)) * style.taskList.view.indent())
            }
        }
    }
    
    
    @ViewBuilder
    private func taskMarkerView(
        style: MDTaskListStyle.MarkerStyle,
        context: MDListMarkerContext,
        checked: Bool
    ) -> some View {
        if let markerView = style.markerView {
            markerView(context)
        } else {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? style.checkedColor() : style.uncheckedColor())
        }
    }
}
