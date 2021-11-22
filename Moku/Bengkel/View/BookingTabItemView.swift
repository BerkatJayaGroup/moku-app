//
//  BookingTabItemView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 16/11/21.
//

import SwiftUI
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
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
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
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }
            }.navigationTitle("Booking")
                .navigationBarColor(AppColor.primaryColor)
        }.background(Color(.systemGroupedBackground))
            .onAppear {
                if let id = Auth.auth().currentUser?.uid {
                    viewModel.getBengkelOrders(bengkelId: id)
                }
            }
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
                    isDetailBookingModalPresented.toggle()
                }.padding()
                    .frame(width: 100, height: 30)
                    .background(AppColor.primaryColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .font(.caption)
            }
        }.onTapGesture {
            isDetailBookingModalPresented.toggle()
        }
        .sheet(isPresented: $isDetailBookingModalPresented) {
            if let id = Auth.auth().currentUser?.uid {
                viewModel.getBengkelOrders(bengkelId: id)
            }
        } content: {
            DetailBooking(order: order)
        }
    }

    private func currentBookingSection(order: [Order]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(0..<order.count) { index in
                    currentBookingCard(order: order[index])
                        .padding(10)
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
                    if mekanik.name.isEmpty {
                        Text("Tidak ada nama mekanik").font(.caption)
                    } else {
                        Text(mekanik.name).font(.caption)
                    }
                } else {
                    Text("Tidak ada nama mekanik").font(.caption)
                }
            }
            HStack {
                Spacer()
                showStatus(status: order.status)
            }
        }.onAppear {
            viewModel.getCustomerFromOrders(customerId: order.customerId)
        }
        .onTapGesture {
            isDetailBookingModalPresented.toggle()
        }
        .sheet(isPresented: $isDetailBookingModalPresented) {
            guard let id = Auth.auth().currentUser?.uid else { return }
            viewModel.getBengkelOrders(bengkelId: id)
        } content: {
            DetailBooking(order: order)
        }
    }

    @ViewBuilder private func showStatus(status: Order.Status) -> some View {
        if status == .onProgress {
            Text(status.rawValue)
                .font(.caption)
                .padding(5)
                .background(AppColor.salmonOrange)
                .foregroundColor(AppColor.primaryColor)
                .cornerRadius(15)
        } else if status == .done {
            Text(status.rawValue)
                .font(.caption)
                .padding(5)
                .background(Color.systemBlue)
                .foregroundColor(Color.blue)
                .cornerRadius(15)
        }
    }
}

struct BookingTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        BookingTabItemView()
    }
}
