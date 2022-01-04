//
//  EditProfileModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 11/11/21.
//

import SwiftUI

struct EditProfileModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""

    @ObservedObject var garageTabViewModel: GarageTabViewModel = .shared

    var customer: Customer

    func header(title: String) -> some View {
        Text(title).headerStyle()
    }

    init(customer: Customer) {
        self.customer = customer
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    textField(title: "NAMA", placeholder: customer.name, text: $name)
                    textField(title: "NOMOR TELEPON", placeholder: customer.phoneNumber, text: $phoneNumber, keyboardType: .numberPad)
                }.padding()
            }
            .navigationBarTitle("Detail Servis", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Tutup") {
                    presentationMode.wrappedValue.dismiss()
            },
                trailing: !name.isEmpty || !phoneNumber.isEmpty ? AnyView(Button("Simpan") {
                    let updatedCustomer = Customer(id: customer.id, name: !name.isEmpty ? self.name : customer.name, phoneNumber: !phoneNumber.isEmpty ? self.phoneNumber : customer.phoneNumber)
                    garageTabViewModel.update(updatedCustomer)
                    presentationMode.wrappedValue.dismiss()
            }) : AnyView(EmptyView()) )
        }
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        Section(header: header(title: title)) {
            VStack(alignment: .trailing) {
                TextField(placeholder, text: text)
                    .font(.subheadline)
                    .keyboardType(keyboardType)
                    .padding(10)
                    .background(AppColor.lightGray)
                    .cornerRadius(8)
            }
        }
    }
}
