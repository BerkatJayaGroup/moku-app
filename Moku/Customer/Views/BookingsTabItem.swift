//
//  BookingsTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import SwiftUI
import FirebaseAuth
import SwiftUIX

struct BookingsTabItem: View {
    @StateObject private var viewModel = ViewModel()
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                RactBg()
                    .frame(height: 144)
                    .foregroundColor(Color("PrimaryColor"))
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    Picker("Bookings", selection: $viewModel.segmentType) {
                        Text("Dalam Proses").tag(0)
                        Text("Terjadwal").tag(1)
                        Text("Riwayat").tag(2)
                    }
                    .pickerStyle(.segmented)
                    if viewModel.filteredOrders.isEmpty == false {
                        ScrollView {
                            VStack {
                                ForEach(viewModel.filteredOrders, id: \.id) { item in
                                    NavigationLink(destination: BookingDetail(order: item)) {
                                        BookingComponentList(order: item)
                                            .padding(5)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                                            .foregroundColor(.black)
                                    }
                                }
                            }.padding(10)
                        }
                    } else {
                        Spacer()
                        BookingEmptyComponent(state: viewModel.segmentType == 0)
                        Spacer()
                    }
                }
                .padding(20)
                .navigationTitle("Bookings")
            }
        }
    }
}

struct BookingsTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BookingsTabItem()
    }
}
