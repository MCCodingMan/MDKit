//
//  MDLinkStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

public struct MDLinkStyle: MDContentStyle {
    public typealias Value = MDLinkContext
    
    public typealias Content = AnyView
    
    public var body: bodyBuilder?
    
    public var text: MDTextStyle
    
    public init(body: bodyBuilder? = nil, text: MDTextStyle) {
        self.body = body
        self.text = text
    }
}
