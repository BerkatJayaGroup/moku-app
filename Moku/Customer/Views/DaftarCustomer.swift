//
//  DaftarCustomer.swift
//  Moku
//
//  Created by Dicky Buwono on 26/10/21.
//

import SwiftUI

struct DaftarCustomer: View {
    @State private var name: String = ""
    @State private var nomorTelepon: String = ""
    @State private var email: String = ""
    @State private var motor: String = ""
    @State private var isEmailValid: Bool = true
    @State private var nameCheck: Bool = true
    @State private var nomorCheck: Bool = true
    @State private var motorCheck: Bool = true
    @State private var showModal = false
    
    @ObservedObject var customerViewModel: CustomerViewModel = .shared
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    
                    Text("NAMA")
                        .font(.caption2)
                    TextField("Tulis namamu disini", text: $name, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if self.name.isEmpty {
                                self.nameCheck = false
                            } else {
                                self.nameCheck = true
                            }
                        }
                    })
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.bottom)
                    if !self.nameCheck {
                        Text("Nama Wajib Diisi")
                            .offset(y: -10)
                            .font(.caption2)
                            .foregroundColor(Color.red)
                    }
                    
                    Text("NOMOR TELEPON")
                        .font(.caption2)
                    TextField("xxxx-xxxx-xxxx", text: $nomorTelepon, onEditingChanged: {
                        (isChanged) in
                        if !isChanged {
                            if self.nomorTelepon.isEmpty {
                                self.nomorCheck = false
                            } else {
                                self.nomorCheck = true
                            }
                        }
                    })
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)
                        .padding(.bottom)
                    
                    Text("EMAIL")
                        .font(.caption2)
                    TextField("Alamat email", text: $email, onEditingChanged: {
                        (isChanged) in
                        if !isChanged {
                            if self.textFieldValidatorEmail(self.email) {
                                self.isEmailValid = true
                            } else {
                                self.isEmailValid = false
                                self.email = ""
                            }
                        }
                    })
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .autocapitalization(.none)
                        .padding(.bottom)
                    if !self.isEmailValid {
                        Text("Format email tidak valid, gunakan example@domain.com")
                            .font(.caption2)
                            .foregroundColor(Color.red)
                    }
                    
                    Text("MODEL MOTOR")
                        .font(.caption2)
                    Button {
                        self.showModal.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Cari model motormu", text: $motor, onEditingChanged: { (isChanged) in
                                if !isChanged {
                                    if self.motor.isEmpty {
                                        self.motorCheck = false
                                    } else {
                                        self.motorCheck = true
                                    }
                                }
                            })
                                .font(.subheadline)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                        }
                        .foregroundColor(Color(hex: "#b5b5b5"))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                    .sheet(isPresented: $showModal) {
                        ModalSearchMotor(showModal: $showModal)
                    }
                }.padding(20)
                Image("MotorGray")
                    .opacity(0.3)
                    .padding(15)
                Spacer()
                Button(action: {
                    let customer = Customer(name: name,
                                            phoneNumber: nomorTelepon,
                                            motors: [])
                    customerViewModel.create(customer)
                    NavigationLink(destination: Pengaturan)
                }){
                    Text("Lanjutkan")
                        .frame(width: 310, height: 50)
                        .background(name.isEmpty || nomorTelepon.isEmpty || email.isEmpty ? Color(.systemGray6) : Color("PrimaryColor"))
                        .foregroundColor(name.isEmpty || nomorTelepon.isEmpty || email.isEmpty ? .gray : .white)
                        .cornerRadius(10)
                        .padding()
                        .disabled(name.isEmpty || nomorTelepon.isEmpty || email.isEmpty)
                }
                
            }
            .navigationTitle("Profil Diri")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    private func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct DaftarCustomer_Previews: PreviewProvider {
    static var previews: some View {
        DaftarCustomer()
    }
}
