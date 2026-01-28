import SwiftUI

public struct MDTextView: View {
    let text: String
    let textStyle: MDTextStyle
    
    private let attributedText: AttributedString

    public init(text: String, textStyle: MDTextStyle, inlineTextStyle: MDInlineTextStyle) {
        self.text = text
        self.textStyle = textStyle
        self.attributedText = Self.makeAttributedText(text: text, textStyle: textStyle, inlineTextStyle: inlineTextStyle)
    }

    public var body: some View {
        Text(attributedText)
            .mdBranchView {
                if let lineSpacing = textStyle.lineSpacing {
                    $0.lineSpacing(lineSpacing())
                } else {
                    $0
                }
            }
    }

    private static func makeAttributedText(text: String, textStyle: MDTextStyle, inlineTextStyle: MDInlineTextStyle) -> AttributedString {
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
                    attributed[run.range].foregroundColor = inlineTextStyle.emphasis.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.emphasis.backgroundColor()
                } else if intent.contains(.strikethrough) {
                    attributed[run.range].foregroundColor = inlineTextStyle.strikethrough.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.strikethrough.backgroundColor()
                } else if intent.contains(.stronglyEmphasized) {
                    attributed[run.range].foregroundColor = inlineTextStyle.strong.textColor()
                    attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
                }
            }
            if let link = run.link, link.absoluteString.isEmpty == false {
                attributed[run.range].foregroundColor = inlineTextStyle.link.textColor()
                attributed[run.range].backgroundColor = inlineTextStyle.strong.backgroundColor()
            }
        }
        return attributed
    }
}

