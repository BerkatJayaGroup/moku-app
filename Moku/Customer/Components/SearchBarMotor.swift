//
//  SearchBarMotor.swift
//  Moku
//
//  Created by Devin Winardi on 28/10/21.
//

import SwiftUI

struct SearchBarMotor: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray3))
                TextField("Search ...", text: $text)
                    .onTapGesture {
                        self.isEditing = true
                    }
                if isEditing {
                    Button {
                        self.isEditing = false
                        self.text = ""
                    } label: {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 8, alignment: .leading)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemGray6)))
    }
}

struct SearchBarMotor_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarMotor(text: .constant(""))
    }
}
