import Foundation

public struct MDBlockItem: Identifiable {
    public let id: String
    public let block: MDBlock
    
    public init(block: MDBlock, occurrence: Int) {
        self.id = "\(block.hashValue) + \(occurrence)"
        self.block = block
    }
}
