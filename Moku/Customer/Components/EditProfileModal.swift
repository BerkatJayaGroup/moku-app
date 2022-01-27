//
//  EditProfileModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 11/11/21.
//

import SwiftUI
import FirebaseAuth

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
    
    var btnBack: some View {
        Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
            HStack {
                Image(systemName: "chevron.left") // set image here
                    .aspectRatio(contentMode: .fit)
                Text("Back")
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                textField(title: "NAMA", placeholder: customer.name, text: $name)
                textField(title: "NOMOR TELEPON", placeholder: customer.phoneNumber, text: $phoneNumber, keyboardType: .numberPad)
            }.padding()
            Spacer()
            Button {
                try? Auth.auth().signOut()
            } label: {
                HStack {
                    Text("Keluar")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(AppColor.primaryColor)
                .padding(.horizontal)
            }
            .frame(width: 312, height: 44)
            .background(Color(hex: "FFF4E9"))
            .cornerRadius(9)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Profil", displayMode: .inline)
        .navigationBarItems(
            leading: btnBack,
            trailing: !name.isEmpty || !phoneNumber.isEmpty ? AnyView(Button("Sunting") {
                let updatedCustomer = Customer(id: customer.id, name: !name.isEmpty ? self.name : customer.name, phoneNumber: !phoneNumber.isEmpty ? self.phoneNumber : customer.phoneNumber)
                garageTabViewModel.update(updatedCustomer)
                presentationMode.wrappedValue.dismiss()
            }) : AnyView(EmptyView()) )
        
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
