public struct MDDocument: Equatable {
    public var blocks: [MDBlock]

    public init(blocks: [MDBlock]) {
        self.blocks = blocks
    }
}
