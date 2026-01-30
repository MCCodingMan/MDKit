
import Foundation

public extension String {
    
    func blockItems(parser: MDParsing = MDParser()) -> [MDBlockItem] {
        let document = parser.parse(markdown: self)
        let mapped = document.blocks.enumerated().map { idx, block in
            return MDBlockItem(block: block, occurrence: idx)
        }
        return mapped
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
