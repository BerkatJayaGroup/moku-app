//
//  BookingTabItemView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 16/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct BookingTabItemView: View {
    @ObservedObject private var viewModel: BookingTabItemViewModel = .shared

    @State private var isDetailBookingModalPresented = false

    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Booking masuk")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    Spacer()
                    NavigationLink(destination: BookingSeeAllView()) {
                        Text("Lihat semua")
                            .font(.caption2)
                            .foregroundColor(AppColor.primaryColor)
                            .padding(.top)
                            .padding(.horizontal)
                    }
                }
                if let order = viewModel.bengkelOrders {
                    let newOrder = order.filter { order in
                        return order.status == .waitingConfirmation
                    }
                    if newOrder.isEmpty {
                        VStack {
                            Image("pemilik-bengkel")
                            Text("Belum ada bookingan masuk")
                                .foregroundColor(AppColor.darkGray)
                                .multilineTextAlignment(.center)
                        }.padding(70)
                    } else {
                        newBookingSection(order: newOrder)
                    }
                } else {
                    ActivityIndicator(.constant(true))
                }
                Text("Pekerjaan Hari Ini")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal)
                if let order = viewModel.bengkelOrders {
                    let currentOrder = order.filter { order in
                        return order.status == .onProgress && order.schedule.date() == Date().date()
                    }
                    if currentOrder.isEmpty {
                        VStack {
                            Image("pemilik-bengkel")
                            Text("Tidak ada bookingan terjadwal pada hari ini")
                                .foregroundColor(AppColor.darkGray)
                                .multilineTextAlignment(.center)
                        }.padding(70)

                    } else {
                        currentBookingSection(order: currentOrder)
                    }
                } else {
                    ActivityIndicator(.constant(true))
                }
            }.navigationTitle("Booking")
                .navigationBarColor(AppColor.primaryColor)
        }.background(Color(.systemGroupedBackground))
    }
    private func newBookingSection(order: [Order]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<order.count) { index in
                    bookingCards(order: order[index])
                        .padding(10)
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                }
                if order.count > 10 {
                    VStack {
                        Image("pemilik-bengkel")
                        Text("Lihat Semua Booking")
                    }.padding(10)
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                }
            }.padding(.bottom)
                .padding(.top, 5)
                .padding(.horizontal)
        }
    }

    private func bookingCards(order: Order) -> some View {
        VStack(alignment: .leading) {
            Text("\(order.motor.brand.rawValue) \(order.motor.model)").font(.subheadline).fontWeight(.bold)
            HStack {
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(order.typeOfService.rawValue).font(.caption)
                Spacer()
            }
            HStack {
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(order.schedule.date()).font(.caption)
                Spacer()
            }
            HStack {
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(order.schedule.time()).font(.caption)
                Spacer()
                Button("Terima") {

                }.padding()
                    .frame(width: 100, height: 30)
                    .background(AppColor.primaryColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .font(.caption)
            }
        }.onTapGesture {
            isDetailBookingModalPresented.toggle()
        }.sheet(isPresented: $isDetailBookingModalPresented) {
            // TODO: Navigate to modal Detail Booking
            // ex: DetailBooking(order)
        }
    }

    private func currentBookingSection(order: [Order]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(0..<order.count) { index in
                    bookingCards(order: order[index])
                        .padding(10)
                        .frame(width: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                }
            }.padding(.bottom)
                .padding(.top, 5)
                .padding(.horizontal)
        }
    }

    private func currentBookingCard(order: Order) -> some View {
        VStack {
            if let customer = viewModel.customer {
                Text(customer.name)
            }

            HStack {
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(order.motor.brand.rawValue) \(order.motor.model)").font(.subheadline).fontWeight(.bold)
                Spacer()
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(order.schedule.time()).font(.caption)
            }
            HStack {
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(order.typeOfService.rawValue).font(.subheadline).fontWeight(.bold)
                Spacer()
                Image("pemilik-bengkel")
                    .resizable()
                    .frame(width: 20, height: 20)
                if let mekanik = order.mekanik {
                    Text(mekanik.name).font(.caption)
                }
            }
            HStack {
                Spacer()
                Text(order.status.rawValue).font(.caption)
            }
        }.onAppear {
            viewModel.getCustomerFromOrders(customerId: order.customerId)
        }
        .onTapGesture {
            isDetailBookingModalPresented.toggle()
        }.sheet(isPresented: $isDetailBookingModalPresented) {
            // TODO: navigate to detail booking
            // ex: DetailBooking(order)
        }
    }
}

struct BookingTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        BookingTabItemView()
    }
}
