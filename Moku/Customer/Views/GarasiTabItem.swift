//
//  GarasiTabItem.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 09/11/21.
//

import SwiftUI

struct GarasiTabItem: View {
    @State private var index = 0

    @State private var isProfileModalPresented = false
    @State private var isAddMotorModalPresented = false

    @ObservedObject private var viewModel: GarageTabViewModel = .shared

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
            if let customer = viewModel.customer {
                Text(customer.name)
                Spacer()
                Text("Profil").foregroundColor(AppColor.primaryColor)
                    .onTapGesture {
                        isProfileModalPresented.toggle()
                    }.sheet(isPresented: $isProfileModalPresented) {
                        EditProfileModal(customer: customer)
                    }
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
                            .frame(width: 300, height: 300)
                    }
                    VStack {
                        Image("MotorGray")
                        Button("+ Tambah Motor Baru") {
                            // TODO: add modal tambah motor
                        }.padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryColor"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                            .padding(.horizontal)
                    }.padding()
                        .frame(width: 300, height: 300)
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
                Spacer()
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
                    OrderCards(order: orders[index])
                }
            }

        }
    }
}

struct OrderCards: View {
    @ObservedObject private var viewModel: GarageTabViewModel = .shared
    @State private var isModalPresented = false
    var orderDetail: Order
    let dateFormatter = DateFormatter()

    init(order: Order) {
        orderDetail = order
        viewModel.getBengkelFromOrder(bengkelId: order.bengkelId)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.bengkel?.name ?? "Loading...")
            HStack {
                VStack(alignment: .leading) {
                    Text(orderDetail.motor.brand.rawValue)
                    Text(orderDetail.typeOfService.rawValue)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(dateFormatter.string(from: orderDetail.createdAt))
                    Text(viewModel.bengkel?.name ?? "Loading...")
                }
            }
        }.onTapGesture {
            isModalPresented.toggle()
        }.sheet(isPresented: $isModalPresented) {
            if let bengkelDetail = viewModel.bengkel {
                OrderHistoryDetailModal(bengkel: bengkelDetail, order: orderDetail)
            }
        }
    }
}

struct GarasiTabItem_Previews: PreviewProvider {
    static var previews: some View {
        GarasiTabItem()
    }
}
