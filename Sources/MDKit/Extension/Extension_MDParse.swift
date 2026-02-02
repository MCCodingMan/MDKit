
import Foundation

public extension String {
    
    func blockItems(parser: MDParsing = MDParser(), id: String = UUID().uuidString) -> [MDBlockItem] {
        let document = parser.parse(markdown: self)
        var oldItems = ParseManager.items(for: id)
        let mapped = document.blocks.enumerated().map { idx, block in
            if let oldItem = oldItems.first(where: { $0.id == "\(idx)" }) {
                oldItem.updateBlock(block)
                return oldItem
            } else {
                return MDBlockItem(block: block, occurrence: idx)
            }
        }
        ParseManager.save(mapped, for: id)
        return mapped
    }
}

class ParseManager {
    nonisolated(unsafe) static private let shared = ParseManager()
    
    private var parsedMap: [String: [MDBlockItem]] = [:]
    
    static func save(_ items: [MDBlockItem], for id: String) {
        shared.parsedMap[id] = items
    }
    
    static func items(for id: String) -> [MDBlockItem] {
        shared.parsedMap[id] ?? []
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
