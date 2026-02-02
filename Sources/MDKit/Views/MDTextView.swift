import SwiftUI
import Combine

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
    @State private var lock = NSLock()
    @State private var completeTask = PassthroughSubject<Void, Never>()
    
    var fadeTextIsEmpty: Bool {
        fadeTexts.contains(where: { $0 != "" })
    }
    
    public var body: some View {
        totalText()
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
                if oldValue == "" && !fadeTextIsEmpty {
                    displayedText = text
                    displayedAttText = makeAttributedText(text: displayedText)
                } else {
                    handleTextChange(from: oldValue, to: text)
                }
                oldValue = text
            }
            .onReceive(completeTask.debounce(for: .seconds(0.1), scheduler: RunLoop.main)) {
                if fadeTextIsEmpty {
                    moveFadeText()
                }
            }
    }
    
    private func handleTextChange(from oldValue: String, to newValue: String) {
        guard newValue != oldValue else { return }
        if newValue.hasPrefix(oldValue) {
            let appendText = String(newValue.dropFirst(oldValue.count))
            moveFadeText(with: appendText)
        } else {
            lock.lock()
            displayedText = text
            displayedAttText = makeAttributedText(text: displayedText)
            fadeTexts = Array(repeating: "", count: 3)
            lock.unlock()
        }
    }
    
    private func moveFadeText(with append: String = "") {
        lock.lock()
        // 将第一个淡入文本加入已显示文本
        displayedText += fadeTexts[0]
        displayedAttText = makeAttributedText(text: displayedText)
        // 所有淡入文本向前移动一位
        fadeTexts.removeFirst()
        fadeTexts.append(append)
        completeTask.send(())
        lock.unlock()
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
        var attributed = (try? AttributedString(
            markdown: text,
            options: AttributedString.MarkdownParsingOptions(
                interpretedSyntax: .inlineOnlyPreservingWhitespace
            )
        )) ?? AttributedString(text)
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

