//
//  DaftarCustomer.swift
//  Moku
//
//  Created by Dicky Buwono on 26/10/21.
//

import SwiftUI
import FirebaseAuth

struct DaftarCustomer: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = ViewModel()
    @State var isInputActive: Bool = false
    @ObservedObject var data = JsonHelper()

    var btnBack : some View {

        Button {
            self.presentationMode.wrappedValue.dismiss()
        }label: {
                HStack {
                Image(systemName: "chevron.backward")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(AppColor.primaryColor)
                    Text("Kembali")
                        .foregroundColor(AppColor.primaryColor)
                }
            }
        }

    var body: some View {
        VStack(alignment: .center) {
          ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        
                        Text("NOMOR TELEPON")
                            .font(.caption2)
                        TextField("08xx-xxxx-xxxx", text: $viewModel.nomorTelepon, onEditingChanged: { isChanged in
                            if !isChanged {
                                viewModel.isPhoneNumberEmpty()
                            }
                        })
                            .font(.subheadline)
                            .padding(15)
                            .background(AppColor.textField)
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                            .padding(.bottom)
                        if !viewModel.nomorCheck {
                            Text("Nomor telepon wajib diisi")
                                .offset(y: -10)
                                .font(.caption2)
                                .foregroundColor(Color.red)
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
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(AppColor.textField))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.tertiaryLabel)
                            .font(.subheadline)
                            .background(AppColor.textField)
                            .cornerRadius(8)
                            .multilineTextAlignment(.leading)
                        }
                        .sheet(isPresented: $viewModel.showModal) {
                            MotorModal(availableMotors: data.motors,
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
                    }

                      Image("MotorGray")
                          .opacity(0.3)
                          .padding(15)

                      VStack(alignment: .leading) {
                          Text("PLAT MOTOR")
                              .font(.caption2)
                          TextField("Plat Motor", text: $viewModel.licensePlate)
                              .font(.subheadline)
                              .padding(15)
                              .background(AppColor.textField)
                              .cornerRadius(8)
                              .autocapitalization(.none)
                              .autocapitalization(.none)
                              .padding(.bottom)

                          Text("TAHUN BELI")
                              .font(.caption2)
                          TextField("Tahun beli", text: $viewModel.year)
                              .keyboardType(.numberPad)
                              .font(.subheadline)
                              .padding(15)
                              .background(AppColor.textField)
                              .cornerRadius(8)
                              .autocapitalization(.none)
                              .autocapitalization(.none)
                              .padding(.bottom)
                      }
                }
            }
            .padding(20)
            Spacer()
            Button {
                if viewModel.isFormInvalid {
                    viewModel.isPhoneNumberEmpty()
                    viewModel.isMotorEmpty()
                } else {
                    NotificationService.shared.getToken { token in
                        if let motor = viewModel.motor {
                            let motorNew = Motor(
                                brand: motor.brand,
                                model: motor.model,
                                cc: motor.cc,
                                licensePlate: viewModel.licensePlate,
                                year: viewModel.year)

                            let customer = Customer(
                                name: viewModel.name,
                                phoneNumber: viewModel.nomorTelepon,
                                motors: [motorNew],
                                fcmToken: token
                            )
                            viewModel.create(customer)
                        }
                    }
                }
            } label: {
                Text("Lanjutkan")
                    .fontWeight(.semibold)
                    .padding(.vertical, 16)
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .background(viewModel.nomorTelepon.isEmpty ? Color(.systemGray6) : Color("PrimaryColor"))
                    .foregroundColor(viewModel.name.isEmpty || viewModel.nomorTelepon.isEmpty ? .gray : .white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .navigationBarTitle("Profil Diri", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct DaftarCustomer_Previews: PreviewProvider {
    static var previews: some View {
        DaftarCustomer()
        .previewDevice("iPhone 12")
    }
}
