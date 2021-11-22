//
//  RejectAppointmentModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 22/11/21.
//

import SwiftUI

struct RejectAppointmentModal: View {
    @State var chosenReason: Order.CancelingReason?
    @StateObject var viewModel: AssignMechanicsViewModel

    init(order: Order) {
        let viewModel = AssignMechanicsViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    let rejectReason: [Order.CancelingReason] = [
        .tidakMemilikiAlat,
        .sparepartKosong,
        .bengkelTutup,
        .kurangMekanik
    ]

    var body: some View {
        VStack {
            Text("Pilih Alasan Menolak Pesanan")
                .font(.system(size: 18))
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            List(rejectReason, id: \.self) { reason in
                HStack {
                    Button(reason.rawValue) {
                        chosenReason = reason
                    }
                    Spacer()
                    if chosenReason == reason {
                        Image(systemName: .checkmark).foregroundColor(AppColor.primaryColor)
                    }
                }
            }.listStyle(.plain)
            Spacer()
            Button("Selesai") {
                viewModel.updateStatusOrder(status: Order.Status.rejected, reason: chosenReason)
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
            }.padding()
            .frame(maxWidth: .infinity)
            .background(AppColor.primaryColor)
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal)
        }.frame(height: 400)
    }
}
