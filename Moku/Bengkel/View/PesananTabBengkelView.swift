//
//  PesananTabBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import SwiftUI

struct PesananTabBengkelView: View {
    @StateObject private var viewModel = ViewModel()

    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

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
            .onDisappear(perform: {
                UINavigationBar.appearance().backgroundColor = nil
            })
            .navigationBarItems(trailing: Button(action: {
                viewModel.isHistoryShow = true
            }, label: {
                Image(systemName: "clock.arrow.circlepath")
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            })
            )

        }
    }
}

struct PesananTabBengkelView_Previews: PreviewProvider {
    static var previews: some View {
        PesananTabBengkelView()
    }
}
