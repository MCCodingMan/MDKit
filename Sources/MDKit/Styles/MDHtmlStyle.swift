//
//  MDHtmlStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/3.
//

import SwiftUI

public struct MDHtmlStyle: MDContentStyle {
    public typealias Value = MDTextDetailContext
    
    public typealias Content = AnyView
    
    public var body: bodyBuilder?
    
    public init(body: bodyBuilder? = nil) {
        self.body = body
    }
}
