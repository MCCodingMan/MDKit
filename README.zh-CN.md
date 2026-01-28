# MDKit

[English docs](README.en.md)

MDKit 是一个基于 SwiftUI 的 Markdown 渲染组件库。它将 Markdown 解析为结构化块（blocks），并提供一套可高度定制的样式系统，用于渲染标题、段落、引用、列表、代码块、表格、数学公式、脚注等内容。适用于 iOS 16 及以上的 SwiftUI 项目。

## 中文

### 项目介绍

MDKit 由两部分组成：

- 解析层：使用 `MDParser` 将 Markdown 文本解析为 `MDDocument`，并得到 `MDBlock` 列表。
- 渲染层：使用 `MDBlockView` + `MDStyle` 将每个 block 渲染为 SwiftUI 视图。

依赖：

- LaTeXSwiftUI（数学公式渲染）
- swift-markdown（Markdown 语法解析）

支持的 Markdown 块类型：

- 标题（H1-H6）
- 段落
- 引用
- 无序列表 / 有序列表
- 任务列表
- 代码块（支持语言标识）
- 链接
- 图片
- 表格
- 分割线
- HTML 块
- 脚注
- 行内数学 / 块级数学（LaTeX）
- Mermaid（以文本方式渲染）

### 环境要求

- iOS 16+
- Swift 6.2（与 Package.swift 保持一致）

### 安装

使用 Swift Package Manager：

```swift
dependencies: [
    .package(url: "https://github.com/MCCodingMan/MDKit", .branch: "main")
]
```

### 如何使用

```swift
import SwiftUI
import MDKit

struct MarkdownScreen: View {
    @State private var items: [MDBlockItem] = []
    private let markdown = """
    # 标题
    这是 **Markdown** 段落。

    - 列表项 1
    - 列表项 2

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

### 所有的样式

`MDStyle` 定义了所有可用样式入口：

- header1, header2, header3, header4, header5, header6
- paragraph
- link
- inline（code, emphasis, strong, strikethrough, link）
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

每个样式都对应具体的样式结构，如 `MDTextStyle`、`MDListStyle`、`MDCodeStyle`、`MDImageStyle` 等。

### 如何设置样式

方式一：整体替换 `MDStyle`

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
    .environment(\.mdStyle, customStyle)
```

方式二：只修改某一部分样式

```swift
MDRenderer.makeBlockView(block: item.block)
    .onMarkdownStyle(for: .code) { style in
        style.view.languageView.text = MDTextStyle(
            font: { .system(size: 12, weight: .semibold) },
            color: { .white }
        )
    }
```

### 样式与可配置参数

以下为所有样式结构及其可修改参数（均为闭包形式，运行时可动态更新）：

- 文本：MDTextStyle
  - font: () -> Font
  - color: () -> Color
  - lineSpacing: (() -> CGFloat)?

- 行内文本：MDInlineTextStyle（包含 5 个 MDInlineStyle）
  - code / emphasis / strong / strikethrough / link
    - textColor: () -> Color
    - backgroundColor: () -> Color

- 引用：MDQuoteStyle
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

- 列表：MDListStyle（无序/有序）
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

- 任务列表：MDTaskListStyle
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

- 代码块：MDCodeStyle
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
    - border: MDBorderStyle（color/width/cornerRadius）
  - body: ((MDCodeBlockContext) -> AnyView)?

- 图片：MDImageStyle
  - body: ((MDImageContext) -> AnyView)?
  - text: MDTextStyle
  - view: ViewStyle
    - loadingView: (() -> AnyView)?
    - failureView: (() -> AnyView)?
  - layout: LayoutStyle
    - cornerRadius: () -> CGFloat
    - titleSpacing: () -> CGFloat
    - titleAlignment: () -> Alignment
    - placeholderHeight: () -> CGFloat

- 表格：MDTableStyle
  - text: TextStyle
    - headerText: MDTextStyle
    - bodyText: MDTextStyle
  - view: ViewStyle
    - headerBackgroundColor: () -> Color
    - bodyBackgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - border: MDBorderStyle（color/width/cornerRadius）
    - cellPadding: () -> [Edge: CGFloat?]
    - cellMaxWidth: () -> CGFloat?
    - headerLine: LineStyle（lineWidth/lineColor）
    - bodyLine: LineStyle（lineWidth/lineColor）
  - body: ((MDTableContext) -> AnyView)?

- 分割线：MDDividerStyle
  - line: LineStyle
    - color: () -> Color
    - height: () -> CGFloat
    - padding: () -> [Edge: CGFloat?]
  - body: ((Void) -> AnyView)?

- 脚注：MDFootnoteStyle
  - textStyle: TextStyle
    - label: MDTextStyle
    - content: MDTextStyle
  - viewStyle: ViewStyle
    - spacing: () -> CGFloat
  - body: ((MDFootnoteContext) -> AnyView)?

- 数学：MDMathStyle（行内/块级）
  - text: MDTextStyle
  - body: ((String) -> AnyView)?

- Mermaid：MDMermaidStyle
  - text: TextStyle
    - label: MDTextStyle
    - content: MDTextStyle
  - view: ViewStyle
    - backgroundColor: () -> Color
    - cornerRadius: () -> CGFloat
    - padding: () -> [Edge: CGFloat?]
  - body: ((String) -> AnyView)?

提示：
- 所有样式均可通过 `.onMarkdownStyle(for: .target) { ... }` 在视图层进行局部更新。
- 传入的闭包将在渲染时取值，适合根据主题或环境动态切换。

方式三：自定义渲染视图

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
