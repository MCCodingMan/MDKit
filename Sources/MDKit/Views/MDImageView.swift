//
//  MDImageView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDImageView: View {
    let style: MDStyle
    let url: String
    let title: String?
    var body: some View {
        VStack(spacing: style.image.layout.titleSpacing()) {
            MDCachedAsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                if let loadingView = style.image.view.loadingView {
                    loadingView()
                } else {
                    Color.gray.opacity(0.1)
                        .overlay {
                            ProgressView()
                        }
                }
            } failur: {
                if let failureView = style.image.view.failureView {
                    failureView()
                } else {
                    Color.gray.opacity(0.1)
                }
            }
            .cornerRadius(style.image.layout.cornerRadius())
            .frame(height: style.image.layout.height())
            .frame(maxWidth: .infinity)
            if let title, title.isEmpty == false {
                Text(title)
                    .font(style.image.text.font())
                    .foregroundColor(style.image.text.color())
                    .frame(maxWidth: .infinity, alignment: style.image.layout.titleAlignment())
            }
        }
    }
}
