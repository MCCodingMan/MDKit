import SwiftUI
import MDKit
import Highlightr

final class MDHighlightr {
    static private let shared = MDHighlightr()
    private static let cache = NSCache<NSString, NSAttributedString>()
    private static let lock = NSLock()
    private static let highlightLock = NSLock()
    private static var cachedCodesByLanguage: [String: Set<String>] = [:]
    
    private let highlightr: Highlightr?
    
    private init() {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "monokai-sublime")
        self.highlightr = highlightr
        MDHighlightr.cache.countLimit = 200
        MDHighlightr.cache.totalCostLimit = 2_000_000
    }
    
    @discardableResult
    static func lightr(for code: String, language: String?) -> NSAttributedString {
        guard let highlightr = shared.highlightr, let lowerLanguage = language?.lowercased() else {
            return NSAttributedString(string: code)
        }
        
        let key = cacheKey(code, language: lowerLanguage)
        if let cached = cache.object(forKey: key) {
            return cached
        }
        
        let result: NSAttributedString
        highlightLock.lock()
        if highlightr.supportedLanguages().contains(where: { $0.lowercased() == lowerLanguage }) {
            result = highlightr.highlight(code, as: lowerLanguage, fastRender: true) ?? NSAttributedString(string: code)
        } else {
            result = NSAttributedString(string: code)
        }
        highlightLock.unlock()
        
        lock.lock()
        var codes = cachedCodesByLanguage[lowerLanguage] ?? []
        codes = Set(codes.filter { cache.object(forKey: cacheKey($0, language: lowerLanguage)) != nil })
        if codes.isEmpty == false {
            for existing in codes where code.hasPrefix(existing) && code.count > existing.count {
                cache.removeObject(forKey: cacheKey(existing, language: lowerLanguage))
                codes.remove(existing)
            }
        }
        codes.insert(code)
        cachedCodesByLanguage[lowerLanguage] = codes
        lock.unlock()
        
        cache.setObject(result, forKey: key, cost: code.utf16.count)
        return result
    }
    
    private static func cacheKey(_ code: String, language: String) -> NSString {
        "\(language)::\(code.hashValue)" as NSString
    }
}

struct ContentView: View {
    let markdown = ##"""
    # H1：**粗体** / *斜体* / ***粗斜体*** / ~~删除线~~ / `inline code`
    
    ## H2：标题含 **Bold** 与 *Italic*
    
    ### H3：标题含 ***Bold+Italic*** 与 ~~Strikethrough~~
    
    #### H4：标题含 `code` 与 **_混合_**
    
    ##### H5：标题含 ~~**删除+粗体**~~ 与 *Emphasis*
    
    ###### H6：标题含 ***_Emphasis_*** 与 `x = y`
    
    ---
    
    ## 段落（含样式、行内代码、换行）
    
    这是第一段：包含 **粗体**、*斜体*、***粗斜体***、~~删除线~~、以及行内代码 `Text("Hello")`。  
    这是同一段中的强制换行（上一行末尾有两个空格）。
    
    这是第二段：也可以写一些“对比”描述，比如 **SwiftUI** 与 *UIKit* 的选择，并在句中插入 `@State` 之类的代码标记。  
    再来一行换行示例。
    
    ---
    
    ## 图片（不带标题 / 带标题）
    
    不带标题：
    ![](https://img0.baidu.com/it/u=4272770078,2506464255&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500)
    
    带标题（可选 title）：
    ![SwiftUI Logo Placeholder](https://img0.baidu.com/it/u=4272770078,2506464255&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500 "这是图片标题（title）")
    
    ---
    
    ## 代码块（SwiftUI）
    
    ```Swift
    
    import SwiftUI
    struct ContentView: View {
        @State private var count = 0
        
        var body: some View {
            VStack(spacing: 16) {
                Text("count:\(count)")
                    .font(.title)
                    .monospacedDigit()
        
                Button {
                    count += 1
                } label: {
                    Label("Increment", systemImage: "plus.circle.fill")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    #Preview {
        ContentView()
    }
    ```
    
    ---
    
    ## 数学公式（行内 + 块级）
    
    行内公式示例：当 \(a \neq 0\) 时，二次方程的解为 \(x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}\)。
    
    块级公式示例：
    \[
    \begin{aligned}
    \text{Let } f(x) &= ax^2 + bx + c \\
    \Delta &= b^2 - 4ac \\
    x &= \frac{-b \pm \sqrt{\Delta}}{2a}
    \end{aligned}
    \]
    
    ---
    
    ## 有序列表（子项无序列表，子子项任务列表）
    
    1. 第一项
        - 子项 A
            - [ ] 子子项任务 1
            - [x] 子子项任务 2
        - 子项 B
            - [ ] 子子项任务 3
    2. 第二项
        - 子项 C
            - [x] 子子项任务 4
    
    ---
    
    ## 无序列表（子项有序列表，子子项任务列表）
    
    - 第一组
        1. 子项 1
            - [ ] 子子项任务 A
            - [x] 子子项任务 B
        2. 子项 2
            - [ ] 子子项任务 C
    - 第二组
        1. 子项 3
            - [x] 子子项任务 D
    
    ---
    
    ## 任务列表（子项有序列表，子子项无序列表）
    
    - [ ] 大任务 1
        1. 子步骤 1
            - 细项 a
            - 细项 b
        2. 子步骤 2
            - 细项 c
    - [x] 大任务 2
        1. 子步骤 3
            - 细项 d
    
    ---
    
    ## 链接
    
    - 普通链接：<https://developer.apple.com/xcode/swiftui/>
    - 带文字的链接：[SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
    - 参考式链接：[Apple Developer][apple-dev]
    
    [apple-dev]: https://developer.apple.com
    
    ---
    
    ## 表格
    
    ### 2行2列（行数不含表头）：SwiftUI vs UIKit（简版）
    
    | 框架 | 简述 |
    |---|---|
    | SwiftUI | 声明式 UI，状态驱动 |
    | UIKit | 命令式 UI，成熟稳定 |
    
    ### 2行10列（行数不含表头）：SwiftUI 和 UIKit 优缺点对比（10个维度）
    
    | 维度 | SwiftUI 优点 | SwiftUI 缺点 | UIKit 优点 | UIKit 缺点 | 学习成本 | 适用场景 | 性能/调试 | 生态/组件 | 兼容性 |
    |---|---|---|---|---|---|---|---|---|---|
    | 结论 A | 声明式更快搭建 | 复杂布局有时难控 | 细粒度控制强 | 样板代码较多 | SwiftUI：中 | 新项目/跨平台 | 预览强但调试偶有坑 | 新生态增长快 | 依赖系统版本较新 |
    | 结论 B | 状态驱动清晰 | API/行为随系统演进 | 历史悠久资料多 | 维护大型界面成本高 | UIKit：中-高 | 存量项目/深度定制 | 工具链成熟 | 第三方组件海量 | 兼容老系统更好 |
    
    
    ---
    
    ## 引用（Blockquote）
    
    > 这是一段引用文本。  
    > 第二行同样在引用中，并包含 `inline code` 与 **强调**。
    
    ---
    
    ## 脚注
    
    这句话包含一个脚注标记。[^note1] 也可以再来一个。[^note2]
    
    [^note1]: 脚注 1：用于补充说明信息。
    [^note2]: 脚注 2：例如引用来源或额外解释。
    
    ---
    
    ## Mermaid
    
    ```mermaid
    flowchart TD
    A[Start] --> B{Use SwiftUI?}
    B -- Yes --> C[Build with Views + State]
    B -- No --> D[Build with UIViewController]
    C --> E[Preview & Iterate]
    D --> E
    E --> F[Ship]
    ```
    """##
    
    let markdown1 = ##"""
        
        ## 数学公式（行内 + 块级）
        
        行内公式示例：当 \(a \neq 0\) 时，二次方程的解为 \(x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}\)。
        
        """##
    
    @State private var hasStartedStreaming = false
    @State private var items: [MDBlockItem] = []
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(items) { item in
                    MDRenderer.makeBlockView(item: item)
                }
                .padding(.vertical, 6)
            }
            .padding(.horizontal, 16)
        }
        .mdBranchView(transform: { view in
            if #available(iOS 18.0, *) {
                view.defaultScrollAnchor(.bottom, for: .sizeChanges)
            } else {
                view
            }
        })
        .task {
            await startStreamingMarkdown()
        }
        .onMarkdownStyle(for: .paragraph) { style in
            style.text.lineSpacing = { 6 }
        }
        .onMarkdownStyle(for: .code) { style in
            style.view.contentView.highlightCode = { code, language in
                await MDHighlightr.lightr(for: code, language: language)
            }
//            style.view.contentView.text.lineSpacing = { 0 }
        }
        .onMarkdownStyle(for: .image) { style in
            style.layout.height = { 220 }
        }
    }
    
    @MainActor
    private func startStreamingMarkdown() async {
//        items = markdown.blockItems()
        
        Task {
            var appendIndex: Int = 0
            while appendIndex < markdown.count {
                try? await Task.sleep(for: .seconds(0.01))
                let tempAppendIndex = min(appendIndex + 3, markdown.count)
                let streamedMarkdown = String(markdown.prefix(tempAppendIndex))
                let decodeItems = streamedMarkdown.blockItems()
                decodeItems.forEach {
                    if case .code(let context) = $0.block {
                        MDHighlightr.lightr(for: context.code, language: context.language)
                    }
                }
                appendIndex = tempAppendIndex
                await MainActor.run {
                    items = decodeItems
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


