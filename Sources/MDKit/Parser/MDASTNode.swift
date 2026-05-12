import Foundation

public struct MDASTNode: Sendable, Equatable {
    public static func == (lhs: MDASTNode, rhs: MDASTNode) -> Bool {
        guard type(of: lhs.kind) == type(of: rhs.kind) else { return false }
        return lhs.children == rhs.children &&
               lhs.content == rhs.content &&
               lhs.position == rhs.position
    }
    
    public var kind: MDASTKind
    public var children: [MDASTNode]
    public var content: Content?
    public var position: Int = 0
    
    public enum Content: Sendable, Hashable {
        case text(String)
        case heading(level: Int, content: String)
        case code(language: String?, code: String)
        case link(title: String?, destination: String)
        case image(title: String?, source: String?)
        case listItem(checked: Bool?, index: Int, depth: Int)
        case html(String)
        case table(headers: [String], rows: [[String]])
    }
}
