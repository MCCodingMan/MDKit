

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
            modifier(MDOnChangeModifier(value: value, action: action))
        }
    }
}


private struct MDOnChangeModifier<V: Equatable>: ViewModifier {
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

extension View {
    func mdEdgePadding(_ padding: [Edge: CGFloat?]) -> some View {
        modifier(MDEdgePaddingModifier(padding: padding))
    }
}

private struct MDEdgePaddingModifier: ViewModifier {
    let padding: [Edge: CGFloat?]
    
    func body(content: Content) -> some View {
        padding.reduce(AnyView(content)) { view, item in
            let (edge, value) = item
            if let value {
                return AnyView(view.padding(edgeSet(for: edge), value))
            } else {
                return AnyView(view)
            }
        }
    }
    
    private func edgeSet(for edge: Edge) -> Edge.Set {
        switch edge {
        case .top:
            return .top
        case .leading:
            return .leading
        case .bottom:
            return .bottom
        case .trailing:
            return .trailing
        }
    }
}

private struct MDFirstAppearModifier: ViewModifier {
    let perform: () -> Void
    @State private var isAppear = false
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !isAppear {
                    perform()
                    isAppear = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(MDFirstAppearModifier(perform: perform))
    }
}
