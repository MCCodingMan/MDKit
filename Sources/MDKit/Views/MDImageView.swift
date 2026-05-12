//
//  MDImageView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

struct MDImageView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    var body: some View {
        if let imageContent {
            VStack(spacing: style.image.layout.titleSpacing()) {
                MDCachedAsyncImage(url: URL(string: imageContent.source)) { image in
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
                if let title = imageContent.title, title.isEmpty == false {
                    Text(title)
                        .equatable()
                        .font(style.image.text.font())
                        .foregroundColor(style.image.text.color())
                        .frame(maxWidth: .infinity, alignment: style.image.layout.titleAlignment())
                }
            }
        }
    }
    
    
    var imageContent: (title: String?, source: String)? {
        if case let .image(title, source) = node.content {
            return (title, source ?? "")
        }
        return nil
    }
}
