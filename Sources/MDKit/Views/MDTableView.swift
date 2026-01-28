//
//  AdaptiveTableView.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

import SwiftUI

extension MDTableView {
    
    struct CellData: Identifiable {
        let id = UUID()
        let text: String
    }
}

struct MDTableView: View {
    
    let headers: [CellData]
    let rows: [[CellData]]
    let style: MDTableStyle
    
    // 存储每列的宽度
    @State private var columnWidths: [Int: CGFloat] = [:]
    // 存储每列的宽度
    @State private var rowHeights: [Int: CGFloat] = [:]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(spacing: 0) {
                // 表头
                HStack(spacing: 0) {
                    ForEach(Array(headers.enumerated()), id: \.offset) { idx, header in
                        DataCell(
                            isHeader: true,
                            text: header.text,
                            columnIndex: idx,
                            rowIndex: 0,
                            isLast: false,
                            style: style,
                            columnWidths: $columnWidths,
                            rowHeights: $rowHeights
                        )
                    }
                }
                .background(style.view.headerBackgroundColor())
                
                // 数据行
                ForEach(Array(rows.enumerated()), id: \.offset) { idx, item in
                    HStack(spacing: 0) {
                        ForEach(Array(item.enumerated()), id: \.offset) { index, row in
                            DataCell(
                                isHeader: false,
                                text: row.text,
                                columnIndex: index,
                                rowIndex: idx + 1,
                                isLast: index == item.count - 1,
                                style: style,
                                columnWidths: $columnWidths,
                                rowHeights: $rowHeights
                            )
                        }
                    }
                }
                .background(style.view.bodyBackgroundColor())
            }
            .radiusBorder(style: style.view.border)
        }
        .cornerRadius(style.view.cornerRadius())
    }
}

extension MDTableView {
    // 数据单元格
    struct DataCell: View {
        let isHeader: Bool
        let text: String
        let columnIndex: Int
        let rowIndex: Int
        let isLast: Bool
        let style: MDTableStyle
        @Binding var columnWidths: [Int: CGFloat]
        @Binding var rowHeights: [Int: CGFloat]
        
        var body: some View {
            Text(text)
                .mdEdgePadding(style.view.cellPadding())
                .frame(width: columnWidths[columnIndex], height: rowHeights[rowIndex], alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: style.view.cellMaxWidth())
                .mdBranchView {
                    if isHeader {
                        $0.font(style.text.headerText.font())
                            .foregroundColor(style.text.headerText.color())
                            .overlay(alignment: .trailing) {
                                if !isLast {
                                    style.view.headerLine.lineColor()
                                        .frame(width: style.view.headerLine.lineWidth())
                                }
                            }
                    } else {
                        $0.font(style.text.bodyText.font())
                            .foregroundColor(style.text.bodyText.color())
                            .overlay(alignment: .trailing) {
                                if !isLast {
                                    style.view.bodyLine.lineColor()
                                        .frame(width: style.view.bodyLine.lineWidth())
                                }
                            }
                    }
                }
                .onGeometryChange(for: CGSize.self, of: { $0.size }) { newValue in
                    updateColumnWidth(newValue.width)
                    updateRowHeight(newValue.height)
                }
            
        }
        
        private func updateColumnWidth(_ width: CGFloat) {
            if columnWidths[columnIndex] == nil || width > (columnWidths[columnIndex] ?? 0) {
                columnWidths[columnIndex] = width
            }
        }
        private func updateRowHeight(_ height: CGFloat) {
            if rowHeights[rowIndex] == nil || height > (rowHeights[rowIndex] ?? 0) {
                rowHeights[rowIndex] = height
            }
        }
    }
}
