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
    init(motor: Motor? = nil, isEditing: Bool = false, motorBefore: Motor? = nil) {
        _viewModel = StateObject(wrappedValue: AddNewMotorViewModel(motor: motor, isEditing: isEditing, motorBefore: motor))
        UITableView.appearance().backgroundColor = .none
        UITableView.appearance().separatorColor = UIColor(AppColor.darkGray)
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    var body: some View {

        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("MODEL MOTOR")
                        .font(.caption2)
                        .foregroundColor(AppColor.darkGray)
                        .padding(.horizontal)
                        .padding(.leading, 15)
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
                        MotorModal(availableMotors: allMotor,
                                   selectedMotor: $viewModel.motor,
                                   showingSheet: $viewModel.show)
                    }.padding(.horizontal)
                }
                Image("MotorGray")
                    .opacity(0.3)
                    .padding(15)
                Form {
                    Section(header: Text("PLAT NOMOR").font(.caption2).foregroundColor(AppColor.darkGray)) {
                        TextField("Plat Nomor", text: $viewModel.plat)
                            .listRowBackground(AppColor.lightGray)
                            .font(.system(size: 15, weight: .regular))
                        TextField("Masa Berlaku", text: $viewModel.masaBerlaku)
                            .listRowBackground(AppColor.lightGray)
                            .font(.system(size: 15, weight: .regular))
                    }
                    Section(header: Text("TAHUN BELI").font(.caption2).foregroundColor(AppColor.darkGray)) {
                        TextField("Plat Nomor", text: $viewModel.tahunBeli)
                            .listRowBackground(AppColor.lightGray)
                            .font(.system(size: 15, weight: .regular))
                    }
                }
                if viewModel.isEditing {
                    Button {
                        viewModel.remove()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Hapus Motor")
                                .font(.system(size: 17, weight: .semibold))
                        }.padding(.horizontal)
                    }
                    .padding()
                    .background(.red)
                    .cornerRadius(9)
                }
            }
            .padding()
            .navigationTitle("Tambah Motor Baru")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Kembali") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(viewModel.isEditing ? "Simpan" : "Tambah") {
                    if viewModel.isEditing {
                        guard let updatedMotor = viewModel.motor else { return }
                        viewModel.update(motorUpdate: updatedMotor)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        viewModel.add()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}