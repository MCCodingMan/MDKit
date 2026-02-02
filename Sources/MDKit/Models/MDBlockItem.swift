import Foundation

public final class MDBlockItem: ObservableObject, Identifiable, Hashable {
    public static func == (lhs: MDBlockItem, rhs: MDBlockItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    @Published public var block: MDBlock
    
    public init(block: MDBlock, occurrence: Int) {
//        self.id = "\(block.hashValue) + \(occurrence)"
        self.id = "\(occurrence)"
        self.block = block
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(block)
    }
    
    func updateBlock(_ block: MDBlock) {
        self.block = block
    }
}
