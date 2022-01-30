//
//  HistoryOrderView.swift
//  Moku
//
//  Created by Mac-albert on 25/11/21.
//

import SwiftUI

struct HistoryOrderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var bengkelOrders: [Order]

    var body: some View {
        VStack {
            ScrollView {
                if let bengkelOrders = bengkelOrders {
                    LazyVStack {
                        ForEach(bengkelOrders, id: \.id) { order in
                            if order.status == .done || order.status == .rejected {
                                NavigationLink(destination: {
                                    DetailBooking(order: order)
                                }, label: {
                                    ReviewCell(order: order)
                                })
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.25)
                                    .background(AppColor.primaryBackground)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarItems(leading: Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 3) {
                Image(systemName: "chevron.backward")
                Text("Kembali")
            }
            .foregroundColor(.white)
        })
        .navigationBarTitle("Riwayat Pesanan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
