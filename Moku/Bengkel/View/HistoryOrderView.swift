//
//  HistoryOrderView.swift
//  Moku
//
//  Created by Mac-albert on 25/11/21.
//

import SwiftUI

struct HistoryOrderView: View {
    var bengkelOrders: [Order]

    var body: some View {
        VStack {
            ScrollView {
                if let bengkelOrders = bengkelOrders {
                    LazyVStack {
                        ForEach(bengkelOrders, id: \.id) { order in
                            if order.status == .done || order.status == .rejected {
                                NavigationLink {
                                    DetailBooking(order: order)
                                } label: {
                                    ReviewCell(order: order)
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }.padding()
                }
            }
        }.navigationBarTitle("Riwayat Pesanan", displayMode: .inline)
    }
}
