//
//  UserMotorModal.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

let motors: [Motor] = [
    Motor(brand: .yamaha, model: "Scoopy", cc: 110),
    Motor(brand: .yamaha, model: "Mio", cc: 110),
    Motor(brand: .yamaha, model: "Jupiter", cc: 120)
]

struct MotorModal: View {

    @Environment(\.presentationMode) var presentationMode
    @Binding var data: String
    @Binding var showingSheet: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(motors) { item in
                    Button {
                        self.data = "\(item.model)"
                        self.showingSheet = false
                    }label: {
                        HStack {
                            Text(item.model)
                            Spacer()

                            if item.model == data {
                                Image(systemName: "checkmark")
                            }
                        }
                    }.foregroundColor(.black)

                }
            }
            .listStyle(.plain)
            .navigationTitle("Daftar Motor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        self.showingSheet = false
                    }label: {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.backward")
                            Text("Kembali")
                        }

                    }.foregroundColor(Color("PrimaryColor"))
            )
        }

    }
}

struct UserMotorModal_Previews: PreviewProvider {
    static var previews: some View {
        MotorModal(data: .constant("hello"), showingSheet: .constant(true))
    }
}
