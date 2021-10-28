//
//  addMekanik.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI

struct AddMekanik: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showSheetView: Bool
    @State var mechanicName: String?

    var body: some View {
            VStack {
                Image(systemName: "number")
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(16)
                Text("Tambah Foto")
                    .font(Font.system(size: 16, weight: .regular))
                    .foregroundColor(Color("PrimaryColor"))
                VStack(alignment: .leading) {
                    Text("NAMA MEKANIK")
                        .font(Font.system(size: 11, weight: .regular))
                    TextField("Tulis Nama Mekanik", text: $mechanicName)
                        .frame(width: .infinity, height: 40)
                        .background(Color(hex: "F3F3F3"))
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding()
            .edgesIgnoringSafeArea(.leading)
            .toolbar {
                Button {
                    print("Dismissing sheet view...")
                } label: {
                    Text("Tambah")
                }
            }
            .navigationBarTitle("Tambah Mekanik", displayMode: .inline)
    }
}

struct AddMekanik_Previews: PreviewProvider {
    static var previews: some View {
        AddMekanik(showSheetView: .constant(true), mechanicName: "Heru")
    }
}
