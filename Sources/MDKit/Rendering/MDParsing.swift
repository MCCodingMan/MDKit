/// Markdown 解析协议，负责将文本转换为结构化文档
public protocol MDParsing {
    /// 将 Markdown 字符串解析为 MDDocument
    func parse(markdown: String) -> MDDocument
}
