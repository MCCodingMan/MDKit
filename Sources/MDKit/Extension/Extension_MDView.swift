

import SwiftUI

extension View {
    public func mdBranchView<Content: View>(@ViewBuilder transform: (Self) -> Content) -> some View {
        transform(self)
    }
    
    func radiusBorder(style: MDBorderStyle) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius())
                .stroke(style.color(), lineWidth: style.width())
        )
        .cornerRadius(style.cornerRadius())
    }
}
