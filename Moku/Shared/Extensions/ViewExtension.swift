//
//  ViewExtension.swift
//  Moku
//
//  Created by Christianto Budisaputra on 29/10/21.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct HeaderText: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.caption2).foregroundColor(.black)
    }
}

struct RoundedTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(9)
    }
}

struct AlertText: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.caption2).foregroundColor(.red)
    }
}

extension Text {
    func headerStyle() -> some View {
        modifier(HeaderText())
    }

    func alertStyle() -> some View {
        modifier(AlertText())
    }
}

extension TextField {
    func roundedStyle() -> some View {
        modifier(RoundedTextField())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }

    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }

    func applyShadow() -> some View {
        shadow(color: .black.opacity(0.1), radius: 2, x: 3, y: 3)
    }

    @ViewBuilder func unredacted(when condition: Bool) -> some View {
            if condition {
                unredacted()
            } else {
                // Use default .placeholder or implement your custom effect
                redacted(reason: .placeholder)
            }
        }
}
