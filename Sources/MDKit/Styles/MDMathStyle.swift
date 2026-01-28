import SwiftUI

public struct MDMathStyle: MDContentStyle {
    public typealias Value = String
    public typealias Content = AnyView
    public var body: bodyBuilder?
    public var text: MDTextStyle

    public init(body: bodyBuilder? = nil, text: MDTextStyle) {
        self.body = body
        self.text = text
    }
}
