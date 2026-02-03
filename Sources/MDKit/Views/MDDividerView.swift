//
//  MDDividerView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDDividerView: View {
    let style: MDStyle
    var body: some View {
        Rectangle()
            .fill(style.divider.line.color())
            .frame(height: style.divider.line.height())
            .mdEdgePadding(style.divider.line.padding())
    }
}
