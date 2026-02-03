import Foundation

public struct MDBlockItem: Identifiable {
    public static func == (lhs: MDBlockItem, rhs: MDBlockItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    public var block: MDBlock
    
    public init(block: MDBlock, index: Int) {
        self.id = "\(index)"
        self.block = block
    }
}
