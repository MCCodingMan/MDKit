
import Foundation

/// LaTeX 标记解析器，用于定位并配对公式分隔符
struct MDLatexParser {
    /// 当前标记在原始字符串中的范围
    let range: Range<String.Index>
    /// 当前标记的原始文本（如 "$"、"$$"、"\\("、"\\)"）
    let tag: Substring
}

extension MDLatexParser {
    /// 判断当前标记是否与另一个标记形成合法的公式边界
    func pairing(parser: MDLatexParser) -> Bool {
        if self.tag == "$$" && parser.tag == "$$" {
            return true
        }
        if self.tag == "$" && parser.tag == "$" {
            return true
        }
        if self.tag == "\\(" && parser.tag == "\\)" {
            return true
        }
        if self.tag == "\\[" && parser.tag == "\\]" {
            return true
        }
        return false
    }
}

extension MDLatexParser {
    /// 查找文本中的公式分隔符范围
    static func findSpecialCharacterRanges(in text: String) -> [Range<String.Index>] {
        do {
            // 使用原始字符串定义正则表达式模式
            let pattern = #"\$\$|\$|\\\(|\\\)|\\\[|\\\]"#
            // 编译正则表达式
            let regex = try NSRegularExpression(pattern: pattern)
            
            // 将整个字符串的范围转换为 NSRange
            let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
            
            // 查找所有匹配项
            let matches = regex.matches(in: text, options: [], range: nsRange)
            
            // 将 NSRange 转换为 Range<String.Index>
            return matches.compactMap { match in
                guard let range = Range(match.range, in: text) else { return nil }
                return range
            }
        } catch {
            print("正则表达式错误: \(error)")
            return []
        }
    }
    
    /// 预处理公式中的换行符，避免被识别为多个段落
    /// - Parameter text: 需要处理的字符
    static func process(in text: String) -> String {
        let ranges = findSpecialCharacterRanges(in: text)
        var parsers: [(MDLatexParser, MDLatexParser)] = []
        var stack: [MDLatexParser] = []
        for range in ranges {
            let tag = text[range]
            let current = MDLatexParser(range: range, tag: tag)
            if let last = stack.last, last.pairing(parser: current) {
                let latexRange = last.range.upperBound..<current.range.lowerBound
                let latex = text[latexRange]
                var valid = true
                if last.tag == "$" {
                    valid = isMathFormula(String(latex))
                }
                if valid {
                    parsers.append((last, current))
                    stack.removeLast()
                } else {
                    stack.removeLast()
                    if current.tag == "$" || current.tag == "$$" || current.tag == "\\(" || current.tag == "\\[" {
                        stack.append(current)
                    }
                    if valid == false {
                        debugPrint("valid=\(latex)")
                    }
                }
            } else {
                if current.tag == "$" || current.tag == "$$" || current.tag == "\\(" || current.tag == "\\[" {
                    stack.append(current)
                }
            }
        }
        if parsers.isEmpty == false {
            var text = text
            parsers.reversed().forEach { (head, last) in
                let latexRange = head.range.upperBound..<last.range.lowerBound
                let latex = text[latexRange]
                let isInline = head.tag == "$" || head.tag == "\\("
                let replacement = isInline ? "$" : "$$"
                text.replaceSubrange(last.range, with: replacement)
                var newLatex = String(latex)
                if let value = newLatex.data(using: .utf8)?.base64EncodedString() {
                    newLatex = value
                }
                text.replaceSubrange(latexRange, with: newLatex)
                text.replaceSubrange(head.range, with: replacement)
            }
            return text
        } else {
            return text
        }
    }
    
    /// 反向解码公式占位内容，恢复原始换行
    public static func removeNewLinePlaceholder(text: String) -> String {
        if let data = Data(base64Encoded: text) {
            return String(data: data, encoding: .utf8) ?? text
        } else {
            return text
        }
    }
}

extension MDLatexParser {
    /// LaTeX 常用命令列表
    static let latexCommands = [
        "\\frac", "\\sqrt", "\\sum", "\\int", "\\prod",
        "\\alpha", "\\beta", "\\gamma", "\\delta", "\\theta",
        "\\pi", "\\sigma", "\\omega", "\\infty", "\\partial",
        "\\left", "\\right", "\\begin", "\\end", "\\text",
        "\\mathbf", "\\mathrm", "\\times", "\\div", "\\pm",
        "\\leq", "\\geq", "\\neq", "\\approx", "\\cdot", "\\boxed", "\\dfrac"
    ]
    
    /// 数学公式中允许的特殊字符
    static let allowedSpecialChars = Set<Character>([
        "+", "-", "*", "/", "=", ">", "<", "±", "∑", "∫",
        "≠", "≈", "≤", "≥", "∞", "∂", "→", "←", "↑", "↓",
        "^", "_", "(", ")", "[", "]", "{", "}", "\\", ".",
        "|", "′", "″", "‴", "!", " ", "2", "3", "4", "5",
        "6", "7", "8", "9", "0", "1"  // 允许数字作为公式的一部分
    ])
    
    /// 判断文本是否符合公式内容特征
    static func isMathFormula(_ text: String) -> Bool {
        // 去掉首尾的 $ 符号
        let formula = text.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
        let maxVariableLength = 10
        // 仅用公式包裹一个变量的情况
        if formula.count < maxVariableLength, formula.allSatisfy({
            $0.isLetter || $0.isNumber
        }) {
            return true
        }
        
        // 如果字符串全是数字，不是数学公式
        let isOnlyNumber = formula.allSatisfy { char in
            char.isNumber || char == " " || char == "," || char == "." || char == "。" || char == "，"
        }
        if isOnlyNumber {
            return false
        }
        
        // 1. 检查是否包含 LaTeX 命令
        let hasLatexCommand = latexCommands.contains { formula.contains($0) }
        
        // 2. 分析字符串中的各个部分
        var currentVariable = ""
        var inBraces = false
        var hasInvalidChar = false
        var hasLetter = false
        var hasMathOperator = false
        
        for char in formula {
            if char == "{" {
                inBraces = true
                continue
            } else if char == "}" {
                inBraces = false
                continue
            }
            
            // 如果在花括号内，继续下一个字符
            if inBraces {
                continue
            }
            
            // 检查是否包含数学运算符
            if ["+", "-", "*", "/", "=", "<", ">", "±", "≠", "≈", "≤", "≥"].contains(char) {
                hasMathOperator = true
            }
            
            if char.isLetter {
                hasLetter = true
                currentVariable.append(char)
            } else {
                // 检查变量长度
                if currentVariable.count > maxVariableLength {
                    return false
                }
                currentVariable = ""
                
                // 检查非字母字符是否合法
                if !allowedSpecialChars.contains(char) {
                    hasInvalidChar = true
                    break
                }
            }
        }
        
        // 检查最后一个变量的长度
        if currentVariable.count > maxVariableLength {
            return false
        }
        
        // 如果有非法字符且不在花括号内，则不是公式
        if hasInvalidChar {
            return false
        }
        
        // 必须满足以下条件之一：
        // 1. 包含 LaTeX 命令
        // 2. 包含数学运算符和字母（变量）
        return hasLatexCommand || (hasMathOperator && hasLetter)
    }
}
