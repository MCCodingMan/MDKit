

import SwiftUI

public extension View {
    func mdBranchView<Content: View>(@ViewBuilder transform: (Self) -> Content) -> some View {
        transform(self)
    }
    
    func ereaseToAnyView() -> AnyView {
        AnyView(self)
    }
    
}

extension View {
    
    func radiusBorder(style: MDBorderStyle) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius())
                .stroke(style.color(), lineWidth: style.width())
        )
        .cornerRadius(style.cornerRadius())
    }
}
