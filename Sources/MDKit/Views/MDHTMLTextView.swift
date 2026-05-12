//
//  MDHTMLView.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//


import SwiftUI  
import UIKit

struct MDHTMLView: MDBaseView {
    let style: MDStyle
    let node: MDASTNode
    private let attributed: NSAttributedString?
    
    init(style: MDStyle, node: MDASTNode) {
        let text =  {
            if case let .html(text) = node.content {
                return text
            }
            return nil
        }() ?? ""
        self.style = style
        self.node = node
        self.attributed = MDHTMLView.makeNSAttributedString(text)
    }
    
    var body: some View {  
        HTMLTextView(attributed: attributed)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private static func makeNSAttributedString(_ text: String) -> NSAttributedString? {
        guard let data = text.data(using: .utf8) else { return nil }
        if let ns = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return ns
        }
        return nil
    }
}

struct HTMLTextView: UIViewRepresentable {
    let attributed: NSAttributedString?
    
    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.attributedText = attributed
        return tv
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributed
    }
}
