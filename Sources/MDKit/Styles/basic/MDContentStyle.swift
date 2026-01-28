//
//  MDContentStyle.swift
//  MDKit
//
//  Created by CoderWan on 2026/1/26.
//

import SwiftUI

public protocol MDContentStyle {
    associatedtype Value
    associatedtype Content: View
    
    typealias bodyBuilder = (Value) -> Content
    
    var body: bodyBuilder? { get set }
}
