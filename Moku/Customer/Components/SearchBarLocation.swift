//
//  SearchBarLocation.swift
//  Moku
//
//  Created by Mac-albert on 22/10/21.
//

import SwiftUI

struct SearchBarLocation: View {

    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemGray3))
            TextField("Cari Alamat", text: $text)
                .onTapGesture {
                    self.isEditing = true
                }
            if isEditing {
                Button {
                    self.isEditing = false
                    self.text = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(Color.gray)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(10)
        .padding(.leading, 5)
        .background(Color.white, alignment: .center)
        .cornerRadius(7)
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
        .padding(.horizontal, 8)
    }
}

struct SearchBarLocation_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarLocation(text: .constant(""))
    }
}
