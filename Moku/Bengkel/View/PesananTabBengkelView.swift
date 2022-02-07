//
//  PesananTabBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import SwiftUI

struct PesananTabBengkelView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    viewModel.showUlasan()
                }
            }
            .background(NavigationLink(destination: HistoryOrderView(bengkelOrders: viewModel.bengkelOrders ?? []), isActive: $viewModel.isHistoryShow) {
                EmptyView()
            })
            .navigationTitle("Pesanan")
            .navigationBarColor(AppColor.primaryColor)
            .navigationBarItems(trailing: Button(action: {
                viewModel.isHistoryShow = true
            }, label: {
                Image(systemName: "clock.arrow.circlepath")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            })
            )
        }.accentColor(.white)
    }
}

struct PesananTabBengkelView_Previews: PreviewProvider {
    static var previews: some View {
        PesananTabBengkelView()
    }
}
