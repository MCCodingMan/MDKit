//
//  MDCachedAsyncImage.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/28.
//

import SwiftUI

final class MDImageCache {
    nonisolated(unsafe) static let shared = MDImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}


struct MDCachedAsyncImage<Content: View>: View {
    let url: URL?
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    
    @State private var phase: AsyncImagePhase = .empty
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await load()
            }
    }
    
    private func load() async {
        guard let url else {
            await update(.failure(URLError(.badURL)))
            return
        }
        if let cached = MDImageCache.shared.image(for: url) {
            await update(.success(Image(uiImage: cached)))
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                MDImageCache.shared.insert(image, for: url)
                await update(.success(Image(uiImage: image)))
            } else {
                await update(.failure(URLError(.cannotDecodeContentData)))
            }
        } catch {
            await update(.failure(error))
        }
    }
    
    @MainActor
    private func update(_ phase: AsyncImagePhase) {
        self.phase = phase
    }
}
