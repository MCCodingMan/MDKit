//
//  MDUnOrderListItemView 2.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/13.
//



import SwiftUI

struct MDTaskListItemView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        HStack(alignment: .top, spacing: style.taskList.view.markerSpacing()) {
            taskMarkerView(
                style: style.taskList.marker,
                checked: listContent.0
            )
            VStack(alignment: .leading, spacing: style.taskList.view.itemSpacing()) {
                ForEach(node.children, id: \.position) { item in
                    MDBlockView(node: item)
                        .equatable()
                }
            }
        }
        .padding(.leading, listContent.1 == 0 ? 0 : style.taskList.view.indent())
    }
    
    
    @ViewBuilder
    private func taskMarkerView(
        style: MDTaskListStyle.MarkerStyle,
        checked: Bool
    ) -> some View {
        if let markerView = style.markerView {
            markerView(.init(index: listContent.1, checked: checked, depthPath: listContent.2))
        } else {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? style.checkedColor() : style.uncheckedColor())
        }
    }
    
    var listContent: (Bool, Int, Int) {
        if case let .listItem(checked, index, depth) = node.content {
            return (checked ?? false, index, depth)
        }
        return (false, 0, 0)
    }
}
