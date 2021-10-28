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
        NavigationView {
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
            .navigationBarTitle("Tambah Mekanik", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showSheetView = false
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Kembali")
                }
            }, trailing: Button(action: {
                print("Dismissing sheet view...")
//                self.showSheetView = false
            }) {
                    Text("Tambah")
            })
            .padding()
            .edgesIgnoringSafeArea(.leading)
        }
//        .navigationTitle("Tambah Mekanik")
//        .toolbar{
//            ToolbarItem(placement: .principal){
//                Text("Tambah Mekanik")
//            }
//            ToolbarItem(placement: .primaryAction){
//                Button("Tambah"){
//
//                }
//            }
//        }
    }

}

struct addMekanik_Previews: PreviewProvider {
    static var previews: some View {
        AddMekanik(showSheetView: .constant(true), mechanicName: "Heru")
    }
}
