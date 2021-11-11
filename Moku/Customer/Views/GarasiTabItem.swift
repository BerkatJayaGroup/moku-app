//
//  GarasiTabItem.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 09/11/21.
//

import SwiftUI

struct GarasiTabItem: View {
    @State private var isModalPresented = false
    @State private var index = 0

    @ObservedObject private var viewModel: GarageTabViewModel = .shared

    let dateFormatter = DateFormatter()
    

    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                profileSection().padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                motorSection()
                Text("Riwayat Servis")
                    .fontWeight(.bold)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                serviceHistorySection().padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    .padding(.horizontal)
            }.navigationTitle("Garasi")
                .navigationBarColor(AppColor.primaryColor)
        }.background(Color(.systemGroupedBackground))

    }

    private func profileSection() -> some View {
        HStack {
            if let name = viewModel.customer?.name {
                Text(name)
                Spacer()
                Text("Profil").foregroundColor(AppColor.primaryColor)
            } else {
                Text("Loading...")
            }
        }.padding(10)
    }

    private func motorSection() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if let motors = viewModel.customer?.motors {
                LazyHStack {
                    ForEach(0..<motors.count) { index in
                        motorCards(motor: motors[index])
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    }
                }
                .padding()
            }

        }
    }

    private func motorCards(motor: Motor) -> some View {
        VStack {
            HStack {
                Text("\(motor.brand.rawValue) \(motor.model)").fontWeight(.bold)
                Spacer()
                Text("Sunting motor").foregroundColor(AppColor.primaryColor)
            }
            Image("MotorGray")
            HStack {
                VStack(alignment: .leading) {
                    Text("Plat Nomor")
                    Text("Tahun")
                    Text("Servis Selanjutnya")
                    Text("Tanggal Bayar Pajak")
                }
                VStack(alignment: .leading) {
                    Text("B 1111 xxx")
                    Text("2017")
                    Text("01-01-2022")
                    Text("02-02-2025")
                }
            }
        }
    }

    private func serviceHistorySection() -> some View {
        VStack {
            let orders = viewModel.customerOrders
            if orders.isEmpty {
                Text("Belum ada riwayat servis")
            } else {
                ForEach(0..<orders.count) { index in
                    orderCards(order: orders[index])
                }
            }

        }
    }

    private func orderCards(order: Order) -> some View {
        VStack(alignment: .leading) {
            Text(viewModel.bengkel?.name ?? "Loading...")
            HStack {
                VStack(alignment: .leading) {
                    Text(order.motor.brand.rawValue)
                    Text(order.typeOfService.rawValue)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(dateFormatter.string(from: order.createdAt))
                    Text(viewModel.customer?.name ?? "Loading...")
                }
            }
        }.onTapGesture {
            isModalPresented.toggle()
        }.fullScreenCover(isPresented: $isModalPresented, content: OrderHistoryDetailModal.init)
    }
    
}

struct GarasiTabItem_Previews: PreviewProvider {
    static var previews: some View {
        GarasiTabItem()
    }
}
