
import Foundation

public extension String {
    
    func blockNode() -> [MDASTNode] {
        MDASTParser.parse(self)
    }
}

extension String {
    var encodeBase64: String {
        Data(utf8).base64EncodedString()
    }
    
    var decodeBase64: String {
        guard let data = Data(base64Encoded: self),
              let decode = String(data: data, encoding: .utf8)
        else {
            return self
        }
        return decode
    }
}


extension String {
    func decodeLatexTag() -> String {
        let pattern = #"\$\$.*?\$\$|\$.*?\$"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return MDLatexParser.removeNewLinePlaceholder(text: self)
        }
        var text = self
        let nsRange = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regex.matches(in: text, range: nsRange)
        for match in matches.reversed() {
            guard let range = Range(match.range, in: text) else { continue }
            let token = String(text[range])
            if token.hasPrefix("$$"), token.hasSuffix("$$"), token.count >= 4 {
                let inner = String(token.dropFirst(2).dropLast(2))
                let decoded = MDLatexParser.removeNewLinePlaceholder(text: inner)
                text.replaceSubrange(range, with: "$$\(decoded)$$")
            } else if token.hasPrefix("$"), token.hasSuffix("$"), token.count >= 2 {
                let inner = String(token.dropFirst().dropLast())
                let decoded = MDLatexParser.removeNewLinePlaceholder(text: inner)
                text.replaceSubrange(range, with: "$\(decoded)$")
            }
        }
        return text
    }
    
    /// 判断文本是否为数学内容，true 为块公式，false 为行内公式
    func isMathString() -> Bool? {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("\\["), trimmed.hasSuffix("\\]") {
            let start = trimmed.index(trimmed.startIndex, offsetBy: 2)
            let end = trimmed.index(before: trimmed.endIndex)
            let content = trimmed[start..<end].trimmingCharacters(in: .whitespacesAndNewlines)
            if content.isEmpty == false {
                return true
            }
        }
        if trimmed.hasPrefix("\\("), trimmed.hasSuffix("\\)") {
            let start = trimmed.index(trimmed.startIndex, offsetBy: 2)
            let end = trimmed.index(before: trimmed.endIndex)
            let content = trimmed[start..<end].trimmingCharacters(in: .whitespacesAndNewlines)
            if content.isEmpty == false {
                return false
            }
        }
        if let start = trimmed.range(of: "$$") {
            if let end = trimmed.range(of: "$$", range: start.upperBound..<trimmed.endIndex) {
                let content = trimmed[start.upperBound..<end.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
                if content.isEmpty == false {
                    return true
                }
            }
        }
        if let s = trimmed.range(of: "\\(") {
            if let e = trimmed.range(of: "\\)", range: s.upperBound..<trimmed.endIndex) {
                let content = trimmed[s.upperBound..<e.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
                if content.isEmpty == false {
                    return false
                }
            }
        }
        if let s = trimmed.range(of: "\\[") {
            if let e = trimmed.range(of: "\\]", range: s.upperBound..<trimmed.endIndex) {
                let content = trimmed[s.upperBound..<e.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
                if content.isEmpty == false {
                    return true
                }
            }
        }
        var index = trimmed.startIndex
        while index < trimmed.endIndex {
            if trimmed[index] == "$" {
                let nextIndex = trimmed.index(after: index)
                if nextIndex < trimmed.endIndex, trimmed[nextIndex] == "$" {
                    index = trimmed.index(after: nextIndex)
                    continue
                }
                if let closing = trimmed[nextIndex...].firstIndex(of: "$") {
                    let content = trimmed[nextIndex..<closing].trimmingCharacters(in: .whitespacesAndNewlines)
                    if content.isEmpty == false {
                        return false
                    }
                }
            }
            index = trimmed.index(after: index)
        }
        return nil
    }
}
