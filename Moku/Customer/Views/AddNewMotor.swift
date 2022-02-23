//
//  AddNewMotor.swift
//  Moku
//
//  Created by Dicky Buwono on 16/11/21.
//

import SwiftUI

struct AddNewMotor: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: AddNewMotorViewModel
    @Binding var isFinishAddData: Bool
    @ObservedObject var data = JsonHelper()
    @State var motors: [Motor] = []
    init(motor: Motor? = nil, isEditing: Bool = true, motorBefore: Motor? = nil, isFinishAddData: Binding<Bool>, motors: [Motor]? = nil) {
        _viewModel = StateObject(wrappedValue: AddNewMotorViewModel(motor: motor, isEditing: isEditing, motorBefore: motor, motors: motors))
        UITableView.appearance().backgroundColor = .none
        UITableView.appearance().separatorColor = UIColor(AppColor.darkGray)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self._isFinishAddData = isFinishAddData
    }
    var body: some View {
        NavigationView {
          VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("MODEL MOTOR")
                        .padding(.top)
                        .font(.caption2)
                        .foregroundColor(AppColor.darkGray)
                    Button {
                        viewModel.show.toggle()
                    } label: {
                        HStack {
                            if let motor = viewModel.motor {
                                Text(motor.model)
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "magnifyingglass")
                                Text("Cari Model Motormu")
                                    .font(.system(size: 15, weight: .regular))
                            }
                        }
                        .foregroundColor(.tertiaryLabel)
                        .font(.subheadline)
                        .background(AppColor.lightGray)
                        .cornerRadius(8)
                        .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(AppColor.lightGray))
                    .sheet(isPresented: $viewModel.show) {
                        MotorModal(availableMotors: data.motors,
                                   selectedMotor: $viewModel.motor,
                                   showingSheet: $viewModel.show)
                    }
                }
            
                Image("MotorIllustration")
                    .opacity(0.3)
                    .padding(15)
              
                VStack(alignment: .leading) {
                    Text("PLAT NOMOR")
                        .font(.caption2)
                        .foregroundColor(AppColor.darkGray)
                
                    VStack {
                        TextField("Plat Nomor", text: $viewModel.plat)
                          .padding(5)
                          .foregroundColor(.black)
                          .font(.subheadline)
                          .background(AppColor.lightGray)
                          .cornerRadius(8)
                        Divider()
                        TextField("Masa Berlaku", text: $viewModel.masaBerlaku)
                          .padding(5)
                          .foregroundColor(.black)
                          .font(.subheadline)
                          .background(AppColor.lightGray)
                          .cornerRadius(8)
                }
                .padding()
                .background(AppColor.lightGray)
                .cornerRadius(8)
                  
                Text("TAHUN KENDARAAN")
                  .padding(.top)
                  .font(.caption2)
                  .foregroundColor(AppColor.darkGray)
                  TextField("Tahun Kendaraan", text: $viewModel.tahunBeli)
                  .padding()
                  .foregroundColor(.black)
                  .font(.subheadline)
                  .background(AppColor.lightGray)
                  .cornerRadius(8)
                }
            }.padding(.horizontal)
            if viewModel.isEditing {
                Button {
                    viewModel.remove {
                        presentationMode.wrappedValue.dismiss()
                        self.isFinishAddData = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "trash")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Hapus Motor")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(Color.red)
                    .padding(.horizontal)
                }
                .frame(width: 312, height: 44)
                .background(Color(hex: "EFBFBF"))
                .cornerRadius(9)
            }
          }
            .padding(.horizontal)
            .padding(.bottom)
            .navigationTitle(viewModel.isEditing ? "Sunting Motor" : "Tambah Motor Baru")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Kembali")
                    }
                },
                trailing: Button(viewModel.isEditing ? "Simpan" : "Tambah") {
                    if viewModel.isEditing {
                        guard let updatedMotor = viewModel.motor else { return }
                        viewModel.update(motorUpdate: updatedMotor) {
                            presentationMode.wrappedValue.dismiss()
                            self.isFinishAddData = true
                        }
                    } else {
                        viewModel.add {
                            presentationMode.wrappedValue.dismiss()
                            self.isFinishAddData = true
                        }
                    }
                }
            )
            .onTapGesture {
                endTextEditing()
            }
        }
    }
}

struct AddNewMotor_Previews: PreviewProvider {
    static var previews: some View {
      AddNewMotor(isFinishAddData: .constant(false))
    }
}
