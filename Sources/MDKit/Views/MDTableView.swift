//
//  AdaptiveTableView.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/27.
//

import SwiftUI

// MARK: - Table Layout
struct TableLayout: Layout {
    let columnCount: Int
    let headerRowCount: Int
    let bodyRowCount: Int
    let alignment: Alignment
    
    var totalRowCount: Int {
        headerRowCount + bodyRowCount
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        if cache.columnWidths.isEmpty {
            cache.calculate(
                subviews: subviews,
                columnCount: columnCount,
                headerRowCount: headerRowCount,
                bodyRowCount: bodyRowCount
            )
        }
        
        let totalWidth = cache.columnWidths.reduce(0, +)
        let totalHeight = cache.rowHeights.reduce(0, +)
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        if cache.columnWidths.isEmpty {
            cache.calculate(
                subviews: subviews,
                columnCount: columnCount,
                headerRowCount: headerRowCount,
                bodyRowCount: bodyRowCount
            )
        }
        
        var y = bounds.minY
        
        for row in 0..<totalRowCount {
            var x = bounds.minX
            let rowHeight = cache.rowHeights[row]
            
            for col in 0..<columnCount {
                let index = row * columnCount + col
                guard index < subviews.count else { continue }
                
                let columnWidth = cache.columnWidths[col]
                
                let point = CGPoint(x: x, y: y)
                let size = CGSize(width: columnWidth, height: rowHeight)
                
                subviews[index].place(
                    at: point,
                    anchor: .topLeading,
                    proposal: ProposedViewSize(size)
                )
                
                x += columnWidth
            }
            
            y += rowHeight
        }
    }
    
    struct Cache {
        var columnWidths: [CGFloat] = []
        var rowHeights: [CGFloat] = []
        
        mutating func calculate(
            subviews: Subviews,
            columnCount: Int,
            headerRowCount: Int,
            bodyRowCount: Int
        ) {
            let totalRowCount = headerRowCount + bodyRowCount
            
            columnWidths = Array(repeating: 0, count: columnCount)
            rowHeights = Array(repeating: 0, count: totalRowCount)
            
            // 第一遍：测量所有子视图，确定每列的宽度
            for (index, subview) in subviews.enumerated() {
                let col = index % columnCount
                
                // 让子视图自由扩展以获取其理想宽度
                let size = subview.sizeThatFits(.unspecified)
                
                columnWidths[col] = max(columnWidths[col], size.width)
            }
            
            // 第二遍：用确定的列宽重新测量，获取正确的行高（包括换行后的高度）
            for (index, subview) in subviews.enumerated() {
                let row = index / columnCount
                let col = index % columnCount
                
                let columnWidth = columnWidths[col]
                
                // 用确定的宽度重新测量，这样 Text 会根据宽度进行换行
                let constrainedSize = subview.sizeThatFits(
                    ProposedViewSize(width: columnWidth, height: nil)
                )
                
                rowHeights[row] = max(rowHeights[row], constrainedSize.height)
            }
        }
    }
    
    func makeCache(subviews: Subviews) -> Cache {
        Cache()
    }
    
    func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.calculate(
            subviews: subviews,
            columnCount: columnCount,
            headerRowCount: headerRowCount,
            bodyRowCount: bodyRowCount
        )
    }
}

// MARK: - MDTableView with Layout
struct MDTableView: View {
    let headers: [CellData]
    let rows: [[CellData]]
    let style: MDTableStyle
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            TableLayout(
                columnCount: headers.count,
                headerRowCount: 1,
                bodyRowCount: rows.count,
                alignment: style.view.cellAlignment()
            ) {
                // 表头 cells
                ForEach(Array(headers.enumerated()), id: \.offset) { idx, header in
                    CellContent(
                        isHeader: true,
                        text: header.text,
                        columnIndex: idx,
                        rowIndex: 0,
                        isLast: idx == headers.count - 1,
                        style: style
                    )
                    .background(style.view.headerBackgroundColor())
                }
                
                // 数据行 cells
                ForEach(Array(rows.enumerated()), id: \.offset) { rowIdx, row in
                    ForEach(Array(row.enumerated()), id: \.offset) { colIdx, cell in
                        CellContent(
                            isHeader: false,
                            text: cell.text,
                            columnIndex: colIdx,
                            rowIndex: rowIdx + 1,
                            isLast: colIdx == row.count - 1,
                            style: style
                        )
                        .background(style.view.bodyBackgroundColor())
                    }
                }
            }
            .radiusBorder(style: style.view.border)
        }
        .cornerRadius(style.view.cornerRadius())
    }
}

// MARK: - Cell Content
extension MDTableView {
    struct CellContent: View {
        let isHeader: Bool
        let text: String
        let columnIndex: Int
        let rowIndex: Int
        let isLast: Bool
        let style: MDTableStyle
        
        var body: some View {
            Text(text)
                .equatable()
                .mdEdgePadding(style.view.cellPadding())
                .lineLimit(nil)  // 允许多行
                .frame(maxWidth: style.view.cellMaxWidth(), alignment: style.view.cellAlignment())
                .fixedSize(horizontal: false, vertical: true)  // 允许水平方向换行
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: style.view.cellAlignment())
                .mdBranchView {
                    if isHeader {
                        $0.font(style.text.headerText.font())
                            .foregroundColor(style.text.headerText.color())
                            .mdBranchView { cell in
                                if let alignment = style.text.headerText.multilineTextAlignment {
                                    cell.multilineTextAlignment(alignment())
                                } else {
                                    cell
                                }
                            }
                    } else {
                        $0.font(style.text.bodyText.font())
                            .foregroundColor(style.text.bodyText.color())
                            .mdBranchView { cell in
                                if let alignment = style.text.bodyText.multilineTextAlignment {
                                    cell.multilineTextAlignment(alignment())
                                } else {
                                    cell
                                }
                            }
                    }
                }
                .overlay(alignment: .trailing) {
                    if !isLast {
                        if isHeader {
                            style.view.headerLine.lineColor()
                                .frame(width: style.view.headerLine.lineWidth())
                        } else {
                            style.view.bodyLine.lineColor()
                                .frame(width: style.view.bodyLine.lineWidth())
                        }
                    }
                }
        }
    }
}

extension MDTableView {
    struct CellData: Identifiable, Hashable {
        let id = UUID()
        let text: String
    }
}
