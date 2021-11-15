//
//  OrderHistoryDetailModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 11/11/21.
//

import SwiftUI

struct OrderHistoryDetailModal: View {
    @Environment(\.presentationMode) var presentationMode

    var orderDetail: Order
    var bengkelDetail: Bengkel

    init(bengkel: Bengkel, order: Order) {
        bengkelDetail = bengkel
        orderDetail = order
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text(bengkelDetail.name).font(.title3).padding(.top)
                        Text(bengkelDetail.address).padding(.bottom)
                        Text("Daftar Servis").font(.title3).fontWeight(.bold)
                        Text(orderDetail.typeOfService.rawValue)
                            .frame(maxWidth: .infinity, minHeight: 300)
                            .background(AppColor.lightGray)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .multilineTextAlignment(.leading)
                        Text("Catatan Bengkel").font(.title3).fontWeight(.bold)
                        Text(orderDetail.notes ?? "Tidak ada catatan bengkel")
                            .frame(maxWidth: .infinity, minHeight: 300)
                            .background(AppColor.lightGray)
                            .cornerRadius(10)
                            .padding(.bottom, 10)
                            .multilineTextAlignment(.leading)
                        Text("Foto Nota").font(.title3).fontWeight(.bold)
                    }
                    Spacer()
                }

            }.padding(.horizontal).navigationBarTitle("Detail Servis", displayMode: .inline).navigationBarItems(leading: Button("Tutup") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
