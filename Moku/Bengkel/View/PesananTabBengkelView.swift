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
                    LazyVStack {
                        ForEach(viewModel.bengkelOrders, id: \.id) { order in
                            NavigationLink {
                                DetailBookingView(order: order)
                            } label: {
                                ReviewCell(order: order)
                            }
                            .padding(10)
                            .frame(
                                width: UIScreen.main.bounds.width * 0.9,
                                height: UIScreen.main.bounds.width * 0.25
                            )
                            .background(AppColor.primaryBackground)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        }
                    }.padding(.vertical, 15)
                }.overlay {
                    VStack {
                        Spacer()
                        Image(systemName: "newspaper")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(AppColor.darkGray)
                        Text("Tidak ada bookingan terjadwal pada hari ini")
                            .font(.system(size: 15))
                            .foregroundColor(AppColor.darkGray)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }.hidden(!viewModel.bengkelOrders.isEmpty)
                }
            }
            .background(
                NavigationLink(
                    destination: HistoryOrderView(bengkelOrders: viewModel.bengkelOrders),
                    isActive: $viewModel.isHistoryShow
                ) { EmptyView() }
            )
            .navigationTitle("Pesanan")
            .navigationBarColor(AppColor.primaryColor)
            .navigationBarItems(
                trailing: Button {
                    viewModel.isHistoryShow = true
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
            )
        }
        .accentColor(.white)
        .onAppear {
            viewModel.viewOnAppear()
        }
    }
}

struct PesananTabBengkelView_Previews: PreviewProvider {
    static var previews: some View {
        PesananTabBengkelView()
    }
}
