//
//  CustomTextField.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let internalPadding: CGFloat = 5
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(internalPadding)
            }
            TextEditor(text: $text)
                .padding(internalPadding)
        }.onAppear {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "Tulis disini", text: .constant("Halo"))
    }
}
