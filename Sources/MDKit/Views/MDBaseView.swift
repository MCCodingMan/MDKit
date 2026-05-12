//
//  MDBaseView.swift
//  MDKit
//
//  Created by CoderWan on 2026/2/13.
//

import SwiftUI

protocol MDBaseView: View, Equatable {
    var style: MDStyle { get }
    
    var node: MDASTNode { get }
    
}

extension MDBaseView {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.node == rhs.node
    }
}
