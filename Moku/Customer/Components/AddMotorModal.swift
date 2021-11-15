//
//  AddMotorModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 12/11/21.
//

import SwiftUI
import FirebaseAuth

struct AddMotorModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var customerViewModel: CustomerViewModel = .shared
    @State private var isActive = false

    @State var userId = Auth.auth().currentUser?.uid

    var motor: Motor
    var body: some View {
        VStack(alignment: .leading) {
            Text("MODEL MOTOR")
                .font(.caption2)
            Button {
                customerViewModel.showModal.toggle()
            } label: {
                HStack {
                    if let motor = customerViewModel.motor {
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
            .sheet(isPresented: $customerViewModel.showModal) {
                MotorModal(availableMotors: allMotor,
                           selectedMotor: $customerViewModel.motor,
                           showingSheet: $customerViewModel.showModal)
            }
            Image("MotorGray")
                .opacity(0.3)
                .padding(15)
        }.padding(20)

    }
}
