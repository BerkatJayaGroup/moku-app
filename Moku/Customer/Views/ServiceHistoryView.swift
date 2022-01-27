//
//  ServiceHistoryView.swift
//  Moku
//
//  Created by Mac-albert on 23/01/22.
//

import SwiftUI

struct ServiceHistoryView: View {
    var customerOrders: [Order]
    
    var body: some View {
        ScrollView{
            if customerOrders.isEmpty {
                Text("Belum ada riwayat servis")
            } else {
                ForEach(customerOrders, id: \.id) { order in
                    OrderCardsSeeAll(order: order).background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Riwayat Servis")
        .navigationBarTitleDisplayMode(.inline)
    }
}
