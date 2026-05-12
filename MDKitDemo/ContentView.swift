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

let a = ##"""
    - 方案 B：macOS 桌面客户端（Apple Silicon 原生）
      - 一、前提确认
        - 设备与系统
          - Mac，Apple Silicon（M1/M2 等）
          - macOS 11+（以官方公告为准）
        - 账号信息
          - 是否已有 API Key：若有，请准备好；如无，请告知以便包含获取路径
      - 二、下载安装与启动
        - 1) 下载入口
            - 官方桌面版：选择 ARM64 / Apple Silicon 版本
            - 替代路径（导航困难时）：官网 → 下载 → macOS 桌面客户端 → Apple Silicon（ARM64）
        - 2) 安装与首次启动
          - 安装：将 DMG 拖拽到应用程序文件夹
          - 信任设置（首次启动提示时）
            - 系统偏好设置 → 安全性与隐私 → 常规 → 允许来自已识别开发者的应用
            - 如仍提示，在“通用”中点击“仍要打开”
          - 启动后完成初次配置向导
      - 三、API Key 绑定与激活
        - 应用内进入 设置 → API Key
        - 粘贴并保存 API Key
        - 无 Key 时：选择“获取密钥”或“试用”，按官方流程申请
      - 四、登录与使用
        - 登录：使用账户信息
        - 启动对话：选择模型与场景，开始对话
        - 基本操作：输入问题 → 发送 → 查看响应；可在设置调整参数（如温度、最大长度）
      - 五、常见问题与排障
        - 无法连接：检查网络/VPN/代理，重新绑定 API Key
        - 首次启动慢：等待本地模型初始化，资源不足时请提升可用内存/CPU
        - 权限问题：确保应用具备必要权限（网络、文件访问等）
      - 六、可选扩展输出（可直接粘贴使用）
        - 下载链接文本模板（ARM64/Apple Silicon）
        - 安装与首次启动的逐字文本清单
        - API Key 绑定步骤的截图式指引
      - 七、需要我提供的后续内容
        - 具体下载链接文本（ARM64/Apple Silicon）
        - 安装与首次启动的逐字文本清单
        - API Key 绑定步骤的截图式指引
      - 八、定制化信息请求
        - 你的 macOS 版本号（如 macOS 13.6）
        - 是否已有 API Key，若有请提供获取方式或直接提供 Key（请注意隐私）
        - 是否需要完整的“入口链接 + 逐步清单”的文本版本
    
    - _附注_: 如果愿意，我也可以生成一页式的“入口链接 + 逐步清单”文本，直接粘贴使用。
    """##

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
    @State private var items: [MDASTNode] = []
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, child in
                    MDRender.makeNodeView(node: child)
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
        }
        .onMarkdownStyle(for: .image) { style in
            style.layout.height = { 220 }
        }
    }
    
    @MainActor
    private func startStreamingMarkdown() async {
//        let temp = a.blockNode()
//        items = temp
//        print(items)

        Task {
            var appendIndex: Int = 0
            let textTTT = a
            while appendIndex < textTTT.count {
                try? await Task.sleep(for: .seconds(0.01))
                let tempAppendIndex = min(appendIndex + 1, textTTT.count)
                let streamedMarkdown = String(textTTT.prefix(tempAppendIndex))
                let decodeItems = streamedMarkdown.blockNode()
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


