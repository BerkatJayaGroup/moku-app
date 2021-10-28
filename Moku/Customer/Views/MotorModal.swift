//
//  UserMotorModal.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

struct MotorModal: View {
    let availableMotors: [Motor]

    @Binding var selectedMotor: Motor?
    @Binding var showingSheet: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(availableMotors) { motor in
                    Button {
                        selectedMotor = motor
                        showingSheet.toggle()
                    } label: {
                        HStack {
                            Text(motor.model)
                            Spacer()

                            if selectedMotor?.model == motor.model {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .foregroundColor(.black)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Daftar Motor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button {
                        self.showingSheet = false
                    } label: {
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
        MotorModal(
            availableMotors: Customer.preview.motors!,
            selectedMotor: .constant(Customer.preview.motors![0]),
            showingSheet: .constant(true)
        )
    }
}
