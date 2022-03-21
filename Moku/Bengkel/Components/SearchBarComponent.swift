//
//  SearchBar.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 29/11/21.
//

import SwiftUI

struct SearchBarComponent: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                } label: {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
        .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)

                if isEditing {
                    Button {
                        self.text = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 80)
                    }
                }
            }
        )
    }
}
