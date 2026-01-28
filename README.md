# MDKit

[中文文档](README.zh-CN.md)

MDKit is a SwiftUI-based Markdown rendering library. It parses Markdown into structured blocks and ships a highly customizable style system for headings, paragraphs, quotes, lists, code blocks, tables, math, footnotes, and more. It targets iOS 16+ SwiftUI apps.

## Overview

MDKit contains two main layers:

- Parsing layer: `MDParser` converts Markdown into `MDDocument` and `MDBlock` arrays.
- Rendering layer: `MDBlockView` + `MDStyle` render each block into SwiftUI views.

Dependencies:

- LaTeXSwiftUI (math rendering)
- swift-markdown (Markdown parsing)

Supported block types:

- Headings (H1-H6)
- Paragraphs
- Quotes
- Unordered / ordered lists
- Task lists
- Code blocks (language-aware)
- Links
- Images
- Tables
- Dividers
- HTML blocks
- Footnotes
- Inline math / block math (LaTeX)
- Mermaid (rendered as text)

## Requirements

- iOS 16+
- Swift 6.2 (matches Package.swift)

## Installation

Swift Package Manager:

```swift
dependencies: [
    .package(url: "git@github.com:MCCodingMan/MDKit", .branch: "main")
]
```

## Usage

```swift
import SwiftUI
import MDKit

struct MarkdownScreen: View {
    @State private var items: [MDBlockItem] = []
    private let markdown = """
    # Title
    This is **Markdown** text.

    - Item 1
    - Item 2

    ```swift
    let value = 1
    ```
    """

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(items) { item in
                    MDRenderer.makeBlockView(block: item.block)
                }
            }
            .padding()
        }
        .task {
            items = await markdown.mdItems()
        }
    }
}
```

## All Styles

`MDStyle` provides these style entries:

- header1, header2, header3, header4, header5, header6
- paragraph
- link
- inline (code, emphasis, strong, strikethrough, link)
- quote
- unorderedList
- orderedList
- taskList
- code
- image
- table
- divider
- footnote
- mathInline
- mathBlock
- mermaid

Each entry maps to a concrete style struct such as `MDTextStyle`, `MDListStyle`, `MDCodeStyle`, and `MDImageStyle`.

## How to Configure Styles

Option 1: Replace the whole `MDStyle`

```swift
let customStyle = MDStyle(
    header1: MDTextStyle(
        font: { .system(size: 28, weight: .bold) },
        color: { .purple }
    ),
    paragraph: MDTextStyle(
        font: { .system(size: 16) },
        color: { .black }
    )
)

MDRenderer.makeBlockView(block: item.block)
//    .environment(\.mdStyle, customStyle)
    .onMarkdownStyle { style  in
        style = customStyle
    }
```

Option 2: Update a single style target

```swift
MDRenderer.makeBlockView(block: item.block)
    .onMarkdownStyle(for: .code) { style in
        style.view.languageView.text = MDTextStyle(
            font: { .system(size: 12, weight: .semibold) },
            color: { .white }
        )
    }
```

## Styles and Configurable Parameters

All style structs expose parameters via closures (evaluated at render time):

- Text: MDTextStyle
  - font: () -> Font
  - color: () -> Color
  - lineSpacing: (() -> CGFloat)?

- Inline text: MDInlineTextStyle (five MDInlineStyle entries)
  - code / emphasis / strong / strikethrough / link
    - textColor: () -> Color
    - backgroundColor: () -> Color

- Quote: MDQuoteStyle
  - body: ((MDQuoteContext) -> AnyView)?
  - view: ViewStyle
    - lineSpacing: () -> CGFloat
    - padding: () -> [Edge: CGFloat?]
    - backgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - border: MDBorderStyle
      - color: () -> Color
      - width: () -> CGFloat
      - cornerRadius: () -> CGFloat
  - line: LineStyle
    - color: () -> Color
    - width: () -> CGFloat
    - lineView: (() -> AnyView)?
  - text: MDTextStyle

- Lists: MDListStyle (unordered/ordered)
  - body: ((MDListContext) -> AnyView)?
  - text: MDTextStyle
  - marker: MarkerStyle
    - markerView: ((MDListMarkerContext) -> AnyView)?
    - markerFont: () -> Font
    - markerColor: () -> Color
  - view: ViewStyle
    - itemSpacing: () -> CGFloat
    - markerSpacing: () -> CGFloat
    - indent: () -> CGFloat

- Task lists: MDTaskListStyle
  - body: ((MDTaskListContext) -> AnyView)?
  - text: MDTextStyle
  - marker: MarkerStyle
    - markerView: ((MDListMarkerContext) -> AnyView)?
    - checkedColor: () -> Color
    - uncheckedColor: () -> Color
  - view: ViewStyle
    - itemSpacing: () -> CGFloat
    - markerSpacing: () -> CGFloat
    - indent: () -> CGFloat

- Code blocks: MDCodeStyle
  - body: ((MDCodeBlockContext) -> AnyView)?
  - view: ViewStyle
    - languageView: LanguageViewStyle
      - view: ((String) -> AnyView)?
      - text: MDTextStyle
      - padding: () -> [Edge: CGFloat?]
      - background: () -> Color
    - contentView: ContentViewStyle
      - view: ((String, String?) -> AnyView)?
      - highlightCode: ((String, String?) -> NSAttributedString)?
      - codeSingleHeight: () -> CGFloat
      - padding: () -> [Edge: CGFloat?]
      - text: MDTextStyle
      - background: () -> Color
  - container: ContainerStyle
    - backgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - border: MDBorderStyle (color/width/cornerRadius)

- Images: MDImageStyle
  - body: ((MDImageContext) -> AnyView)?
  - text: MDTextStyle
  - view: ViewStyle
    - loadingView: (() -> AnyView)?
    - failureView: (() -> AnyView)?
  - layout: LayoutStyle
    - cornerRadius: () -> CGFloat
    - titleSpacing: () -> CGFloat
    - placeholderHeight: () -> CGFloat

- Tables: MDTableStyle
  - body: ((MDTableContext) -> AnyView)?
  - text: TextStyle
    - headerText: MDTextStyle
    - bodyText: MDTextStyle
  - view: ViewStyle
    - headerBackgroundColor: () -> Color
    - bodyBackgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - border: MDBorderStyle (color/width/cornerRadius)
    - cellPadding: () -> [Edge: CGFloat?]
    - cellMaxWidth: () -> CGFloat?
    - headerLine: LineStyle (lineWidth/lineColor)
    - bodyLine: LineStyle (lineWidth/lineColor)

- Divider: MDDividerStyle
  - body: ((Void) -> AnyView)?
  - line: LineStyle
    - color: () -> Color
    - height: () -> CGFloat
    - padding: () -> [Edge: CGFloat?]

- Footnotes: MDFootnoteStyle
  - body: ((MDFootnoteContext) -> AnyView)?
  - textStyle: TextStyle
    - label: MDTextStyle
    - content: MDTextStyle
  - viewStyle: ViewStyle
    - spacing: () -> CGFloat

- Math: MDMathStyle (inline/block)
  - body: ((String) -> AnyView)?
  - text: MDTextStyle

- Mermaid: MDMermaidStyle
  - body: ((String) -> AnyView)?
  - text: TextStyle
    - label: MDTextStyle
    - content: MDTextStyle
  - view: ViewStyle
    - backgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - padding: () -> [Edge: CGFloat?]

Notes:
- Use `.onMarkdownStyle(for: .target) { ... }` to update any part of the style in-place.
- Because values are closures, styles can react to theme or environment changes at render time.

Option 3: Provide a custom view

```swift
MDRenderer.makeBlockView(block: item.block)
    .onMarkdownStyle(for: .quote) { style in
        style.body = { context in
            VStack(alignment: .leading, spacing: 8) {
                ForEach(context.lines.indices, id: \.self) { index in
                    Text(context.lines[index])
                }
            }
        }
    }
```
