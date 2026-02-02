

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
    
    @ViewBuilder
    func onChangeValue<V: Equatable>(_ value: V, action: @escaping (V, V) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            onChange(of: value, action)
        } else {
            modifier(OnChangeModifier(value: value, action: action))
        }
    }
}


struct OnChangeModifier<V: Equatable>: ViewModifier {
    let value: V
    let action: (V, V) -> Void
    
    @State private var oldValue: V?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value) { newValue in
                action(oldValue ?? newValue, newValue)
                oldValue = newValue
            }
            .onAppear {
                oldValue = value
            }
    }
}
