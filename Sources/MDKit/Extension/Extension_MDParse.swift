
import Foundation

public extension String {
    
    func blockItems(cacheParser: MDCachedParser? = nil) -> [MDBlockItem] {
        let document = {
            if let cacheParser {
               return cacheParser.parse(markdown: self)
            } else {
                return MDDocument(blocks: MDParser.parseBlocks(markdown: self))
            }
        }()
        let mapped = document.blocks.enumerated().map { idx, block in
            MDBlockItem(block: block, index: idx)
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
