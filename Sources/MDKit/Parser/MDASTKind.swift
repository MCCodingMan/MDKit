import Foundation
import SwiftUI

public protocol MDASTKind: Sendable, Equatable {
    
    @MainActor
    func makeKindBody(with node: MDASTNode, style: MDStyle) -> AnyView
}
