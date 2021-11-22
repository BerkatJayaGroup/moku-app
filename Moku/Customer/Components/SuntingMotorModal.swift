//
//  SuntingMotorModal.swift
//  Moku
//
//  Created by Dicky Buwono on 18/11/21.
//

import SwiftUI

struct SuntingMotorModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var show: Bool = false
    @State var motor: Motor?
    @State private var plat: String = ""
    @State private var masaBerlaku: String = ""
    @State private var tahunBeli: String = ""
    var body: some View {
        VStack {
            Text("MODEL MOTOR")
                .font(.caption2)
            Button {
                show.toggle()
            } label: {
                HStack {
                    if let motor = motor {
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
            .sheet(isPresented: $show) {
                MotorModal(availableMotors: allMotor,
                           selectedMotor: $motor,
                           showingSheet: $show)
            }
            Image("MotorGray")
                .opacity(0.3)
                .padding(15)
            Form {
                Section(header: Text("PLAT NOMOR").font(.caption2).foregroundColor(AppColor.darkGray)) {
                    TextField("Plat Nomor", text: $plat)
                        .listRowBackground(AppColor.lightGray)
                        .font(.system(size: 15, weight: .regular))
                    TextField("Masa Berlaku", text: $masaBerlaku)
                        .listRowBackground(AppColor.lightGray)
                        .font(.system(size: 15, weight: .regular))
                }
                Section(header: Text("TAHUN BELI").font(.caption2).foregroundColor(AppColor.darkGray)) {
                    TextField("Plat Nomor", text: $tahunBeli)
                        .listRowBackground(AppColor.lightGray)
                        .font(.system(size: 15, weight: .regular))
                }
            }
        }
    }
}

struct SuntingMotorModal_Previews: PreviewProvider {
    static var previews: some View {
        SuntingMotorModal()
    }
}
