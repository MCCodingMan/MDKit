//
//  MDTextDetailStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

public struct MDTextDetailStyle: MDContentStyle {
    public typealias Value = MDTextDetailContext
    
    public typealias Content = AnyView
    
    public var body: bodyBuilder?
    
    public var text: MDTextStyle
    
    public init(body: bodyBuilder? = nil, text: MDTextStyle) {
        self.body = body
        self.text = text
    }
    
}
