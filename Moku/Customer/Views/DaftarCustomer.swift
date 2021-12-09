//
//  DaftarCustomer.swift
//  Moku
//
//  Created by Dicky Buwono on 26/10/21.
//

import SwiftUI
import FirebaseAuth

let allMotor: [Motor] = [Motor(brand: .honda, model: "Beat", cc: 110),
                         Motor(brand: .kawasaki, model: "Z250", cc: 250),
                         Motor(brand: .kawasaki, model: "W175", cc: 175)
]

struct DaftarCustomer: View {
    @StateObject private var viewModel = ViewModel()
    @State var isInputActive: Bool = false
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("NAMA")
                        .font(.caption2)
                    VStack(alignment: .leading) {
                        TextField("Tulis namamu disini", text: $viewModel.name, onEditingChanged: { isChanged in
                            if !isChanged {
                                viewModel.validateEmptyName()
                            }
                        })
                            .font(.subheadline)
                            .padding(15)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.bottom)
                        if !viewModel.nameCheck {
                            Text("Nama wajib diisi")
                                .offset(y: -10)
                                .font(.caption2)
                                .foregroundColor(Color.red)
                        }
                        
                        Text("NOMOR TELEPON")
                            .font(.caption2)
                        TextField("08xx-xxxx-xxxx", text: $viewModel.nomorTelepon, onEditingChanged: { isChanged in
                            if !isChanged {
                                viewModel.isPhoneNumberEmpty()
                            }
                        })
                            .font(.subheadline)
                            .padding(15)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                            .padding(.bottom)
                        if !viewModel.nomorCheck {
                            Text("Nomor telepon wajib diisi")
                                .offset(y: -10)
                                .font(.caption2)
                                .foregroundColor(Color.red)
                        }
                        Text("EMAIL")
                            .font(.caption2)
                        TextField("Alamat email", text: $viewModel.email, onEditingChanged: { isChanged in
                            if !isChanged {
                                if viewModel.textFieldValidatorEmail() {
                                    viewModel.isEmailValid = true
                                } else {
                                    viewModel.isEmailValid = false
                                    viewModel.email = ""
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
                        if !viewModel.isEmailValid {
                            Text("Format email tidak valid, gunakan example@domain.com")
                                .offset(y: -10)
                                .font(.caption2)
                                .foregroundColor(Color.red)
                        }
                        if !viewModel.emailCheck {
                            Text("Email wajib diisi")
                                .offset(y: -10)
                                .font(.caption2)
                                .foregroundColor(Color.red)
                        }
                    }
                    Text("MODEL MOTOR")
                        .font(.caption2)
                    Button {
                        viewModel.showModal.toggle()
                    } label: {
                        HStack {
                            if let motor = viewModel.motor {
                                Text(motor.model)
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "magnifyingglass")
                                Text("Cari Model Motormu")
                            }
                        }
                        .foregroundColor(.tertiaryLabel)
                        .font(.subheadline)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
                    .sheet(isPresented: $viewModel.showModal) {
                        MotorModal(availableMotors: allMotor,
                                   selectedMotor: $viewModel.motor,
                                   showingSheet: $viewModel.showModal)
                    }
                    if !viewModel.motorCheck {
                        Text("Motor wajib diisi")
                            .offset(y: -10)
                            .font(.caption2)
                            .foregroundColor(Color.red)
                            .padding(.top)
                    }
                }.padding(20)
                Image("MotorGray")
                    .opacity(0.3)
                    .padding(15)
                
                VStack(alignment: .leading) {
                    Text("PLAT MOTOR")
                        .font(.caption2)
                    TextField("Plat Motor", text: $viewModel.licensePlate)
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .autocapitalization(.none)
                        .padding(.bottom)
                    
                    Text("Tahun Beli")
                        .font(.caption2)
                    TextField("Tahun beli", text: $viewModel.year)
                        .keyboardType(.numberPad)
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocapitalization(.none)
                        .autocapitalization(.none)
                        .padding(.bottom)
                }.padding()
                
            }
            Spacer()
            
            Button {
                if viewModel.isFormInvalid {
                    viewModel.validateEmptyName()
                    viewModel.isPhoneNumberEmpty()
                    viewModel.isMotorEmpty()
                    viewModel.isEmailEmpty()
                } else {
                    NotificationService.shared.getToken { token in
                        viewModel.motor?.licensePlate = viewModel.licensePlate
                        viewModel.motor?.year = viewModel.year
                        let customer = Customer(
                            name: viewModel.name,
                            phoneNumber: viewModel.nomorTelepon,
                            motors: [viewModel.motor!],
                            fcmToken: token
                        )

                        viewModel.create(customer)
                    }
                }
            } label: {
                Text("Lanjutkan")
                    .fontWeight(.semibold)
                    .padding(.vertical, 16)
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .background(viewModel.name.isEmpty || viewModel.nomorTelepon.isEmpty || viewModel.email.isEmpty ? Color(.systemGray6) : Color("PrimaryColor"))
                    .foregroundColor(viewModel.name.isEmpty || viewModel.nomorTelepon.isEmpty || viewModel.email.isEmpty ? .gray : .white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .navigationBarTitle("Profil Diri", displayMode: .inline)
    }
}

struct DaftarCustomer_Previews: PreviewProvider {
    static var previews: some View {
        DaftarCustomer()
    }
}
