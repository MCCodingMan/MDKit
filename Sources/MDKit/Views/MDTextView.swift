import SwiftUI

public struct MDTextView: View {
    let text: String
    let textStyle: MDTextStyle
    let inlineTextStyle: MDInlineTextStyle
    
    public init(text: String, textStyle: MDTextStyle, inlineTextStyle: MDInlineTextStyle) {
        self.text = text
        self.textStyle = textStyle
        self.inlineTextStyle = inlineTextStyle
    }
    
    @State private var displayedAttText = AttributedString()
    @State private var displayedText = ""
    @State private var fadeTexts: [String] = Array(repeating: "", count: 3)
    @State private var oldValue = ""
    @State private var moveTask: Task<Void, Never>?
    
    var hasFadeText: Bool {
        fadeTexts.contains(where: { $0.isEmpty == false })
    }
    
    public var body: some View {
        totalText()
            .frame(maxWidth: .infinity, alignment: .leading)
            .mdBranchView {
                if let lineSpacing = textStyle.lineSpacing {
                    $0.lineSpacing(lineSpacing())
                } else {
                    $0
                }
            }
            .mdBranchView {
                if let alignment = textStyle.multilineTextAlignment {
                    $0.multilineTextAlignment(alignment())
                } else {
                    $0
                }
            }
            .task(id: text) {
                if oldValue == "" && !hasFadeText {
                    displayedText = text
                    displayedAttText = makeAttributedText(text: displayedText)
                } else {
                    handleTextChange(from: oldValue, to: text)
                }
                oldValue = text
            }
            .onDisappear {
                moveTask?.cancel()
                moveTask = nil
            }
    }
    
    @MainActor
    private func handleTextChange(from oldValue: String, to newValue: String) {
        guard newValue != oldValue else { return }
        if newValue.hasPrefix(oldValue) {
            let appendText = String(newValue.dropFirst(oldValue.count))
            moveFadeText(with: appendText)
        } else {
            moveTask?.cancel()
            displayedText = text
            displayedAttText = makeAttributedText(text: displayedText)
            fadeTexts = Array(repeating: "", count: 3)
        }
    }
    
    @MainActor
    private func moveFadeText(with append: String = "") {
        displayedText += fadeTexts[0]
        displayedAttText = makeAttributedText(text: displayedText)
        fadeTexts.removeFirst()
        fadeTexts.append(append)
        scheduleFadeMoveIfNeeded()
    }
    
    private func totalText() -> Text {
        var result = Text(displayedAttText)
        
        for (index, fadeText) in fadeTexts.enumerated() {
            let appendText = {
                if #available(iOS 17.0, *) {
                    Text(fadeText)
                        .font(textStyle.font())
                        .foregroundStyle(textStyle.color().opacity(1.0 - Double(index) * 0.45))
                } else {
                    Text(fadeText)
                        .font(textStyle.font())
                        .foregroundColor(textStyle.color().opacity(1.0 - Double(index) * 0.45))
                }
            }()
            result = result + appendText
        }
        
        return result
    }
    
    private func makeAttributedText(text: String) -> AttributedString {
        let baseAttributed: AttributedString = {
            if containsInlineMarkdown(text) {
                return (try? AttributedString(
                    markdown: text,
                    options: AttributedString.MarkdownParsingOptions(
                        interpretedSyntax: .inlineOnlyPreservingWhitespace
                    )
                )) ?? AttributedString(text)
            }
            return AttributedString(text)
        }()
        var attributed = baseAttributed
        attributed.foregroundColor = textStyle.color()
        attributed.font = textStyle.font()
        for run in attributed.runs {
            if let intent = run.inlinePresentationIntent {
                if intent.contains(.code) {
                    attributed[run.range].font = textStyle.font().monospaced()
                    attributed[run.range].foregroundColor = inlineTextStyle.code.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.code.backgroundColor()
                } else if intent.contains(.emphasized) {
                    if let weight = inlineTextStyle.emphasis.weight() {
                        attributed[run.range].font = textStyle.font().weight(weight)
                    }
                    attributed[run.range].foregroundColor = inlineTextStyle.emphasis.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.emphasis.backgroundColor()
                } else if intent.contains(.strikethrough) {
                    if let weight = inlineTextStyle.strikethrough.weight() {
                        attributed[run.range].font = textStyle.font().weight(weight)
                    }
                    attributed[run.range].foregroundColor = inlineTextStyle.strikethrough.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.strikethrough.backgroundColor()
                } else if intent.contains(.stronglyEmphasized) {
                    if let weight = inlineTextStyle.strong.weight() {
                        attributed[run.range].font = textStyle.font().weight(weight)
                    }
                    attributed[run.range].foregroundColor = inlineTextStyle.strong.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
                }
            }
            if let link = run.link, link.absoluteString.isEmpty == false {
                if let weight = inlineTextStyle.link.weight() {
                    attributed[run.range].font = textStyle.font().weight(weight)
                }
                attributed[run.range].foregroundColor = inlineTextStyle.link.textColor()
                attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
            }
        }
        return attributed
    }

    private func containsInlineMarkdown(_ text: String) -> Bool {
        let markers: [Character] = ["*", "_", "`", "~", "[", "]", "(", ")"]
        return text.first(where: { markers.contains($0) }) != nil
    }

    @MainActor
    private func scheduleFadeMoveIfNeeded() {
        moveTask?.cancel()
        guard hasFadeText else { return }
        moveTask = Task {
            try? await Task.sleep(nanoseconds: 100_000_000)
            if Task.isCancelled { return }
            await MainActor.run {
                if hasFadeText {
                    moveFadeText()
                }
            }
        }
    }
}

//public struct MDTextView: View {
//    let text: String
//    let textStyle: MDTextStyle
//    
//    private let attributedText: AttributedString
//
//    public init(text: String, textStyle: MDTextStyle, inlineTextStyle: MDInlineTextStyle) {
//        self.text = text
//        self.textStyle = textStyle
//        self.attributedText = Self.makeAttributedText(text: text, textStyle: textStyle, inlineTextStyle: inlineTextStyle)
//    }
//
//    public var body: some View {
//        Text(attributedText)
//            .mdBranchView {
//                if let lineSpacing = textStyle.lineSpacing {
//                    $0.lineSpacing(lineSpacing())
//                } else {
//                    $0
//                }
//            }
//    }
//
//    private static func makeAttributedText(text: String, textStyle: MDTextStyle, inlineTextStyle: MDInlineTextStyle) -> AttributedString {
//        var attributed = (try? AttributedString(
//            markdown: text,
//            options: AttributedString.MarkdownParsingOptions(
//                interpretedSyntax: .inlineOnlyPreservingWhitespace
//            )
//        )) ?? AttributedString(text)
//        attributed.foregroundColor = textStyle.color()
//        attributed.font = textStyle.font()
//        for run in attributed.runs {
//            if let intent = run.inlinePresentationIntent {
//                if intent.contains(.code) {
//                    attributed[run.range].font = textStyle.font().monospaced()
//                    attributed[run.range].foregroundColor = inlineTextStyle.code.textColor()
//                    attributed[run.range].backgroundColor = inlineTextStyle.code.backgroundColor()
//                } else if intent.contains(.emphasized) {
//                    attributed[run.range].foregroundColor = inlineTextStyle.emphasis.textColor()
//                    attributed[run.range].backgroundColor = inlineTextStyle.emphasis.backgroundColor()
//                } else if intent.contains(.strikethrough) {
//                    attributed[run.range].foregroundColor = inlineTextStyle.strikethrough.textColor()
//                    attributed[run.range].backgroundColor = inlineTextStyle.strikethrough.backgroundColor()
//                } else if intent.contains(.stronglyEmphasized) {
//                    attributed[run.range].foregroundColor = inlineTextStyle.strong.textColor()
//                    attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
//                }
//            }
//            if let link = run.link, link.absoluteString.isEmpty == false {
//                attributed[run.range].foregroundColor = inlineTextStyle.link.textColor()
//                attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
//            }
//        }
//        return attributed
//    }
//}
