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
    @State private var isDetailBookingOnProgressPresented = false
    @State private var selectedOrder: Order?
    
    let coloredAppearance = UINavigationBarAppearance()

    init() {
//        let appearance                                      = UITabBarAppearance()
//        UITabBar.appearance().isTranslucent                 = true
//        UITabBar.appearance().backgroundColor               = UIColor(AppColor.grayTab)
//        appearance.shadowColor                              = UIColor.gray
        
        
        coloredAppearance.backgroundColor                   = UIColor(AppColor.primaryColor)
        coloredAppearance.largeTitleTextAttributes          = [.foregroundColor: UIColor.white]
        coloredAppearance.titleTextAttributes               = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance     = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance   = coloredAppearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let orders = viewModel.bengkelOrders {
                    let waitingConfirmationOrder = orders.filter { filteredOrder in
                        return filteredOrder.status == .waitingConfirmation
                    }
                    let onProgressOrder = orders.filter { filteredOrder in
                        return (filteredOrder.status == .onProgress || filteredOrder.status == .scheduled) && filteredOrder.schedule.date() == Date().date()
                    }
                    if !waitingConfirmationOrder.isEmpty || !onProgressOrder.isEmpty {
                        ScrollView {
                            HStack {
                                Text("Booking masuk")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                    .padding(.horizontal)
                                Spacer()
                                if !waitingConfirmationOrder.isEmpty {
                                    NavigationLink(destination: BookingSeeAllView()) {
                                        Text("Lihat semua")
                                            .font(.caption2)
                                            .foregroundColor(AppColor.primaryColor)
                                            .padding(.top)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            if waitingConfirmationOrder.isEmpty {
                                VStack {
                                    Image(systemName: "newspaper")
                                        .foregroundColor(AppColor.brightOrange)
                                    Text("Belum ada bookingan masuk")
                                        .foregroundColor(AppColor.darkGray)
                                        .multilineTextAlignment(.center)
                                }.padding(70)
                            } else {
                                newBookingSection(order: waitingConfirmationOrder)
                            }
                            Text("Pekerjaan Hari Ini")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                                .padding(.horizontal)
                            if onProgressOrder.isEmpty {
                                VStack {
                                    Image(systemName: "newspaper")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(AppColor.darkGray)
                                    Text("Tidak ada bookingan terjadwal pada hari ini")
                                        .font(.system(size: 15))
                                        .foregroundColor(AppColor.darkGray)
                                        .multilineTextAlignment(.center)
                                }.padding(70)
                            } else {
                                currentBookingSection(order: onProgressOrder)
                            }
                        }
                    } else {
                        Image("EmptyStateBengkel")
                        Text("Tidak ada bookingan masuk ataupun terjadwal pada hari ini")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(.systemGray)
                            .padding()
                    }
                } else {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }
            }
            .navigationTitle("Booking")
            .navigationBarColor(AppColor.primaryColor)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            })
            .onAppear {
                if let id = Auth.auth().currentUser?.uid {
                    viewModel.getBengkelOrders(bengkelId: id)
                }
            }
        }
    }
    private func newBookingSection(order: [Order]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(order, id: \.id ) { order in
                    bookingCards(order: order)
                        .padding(10)
                        .frame(width: 300)
                        .background(AppColor.primaryBackground)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                }
                if order.count > 10 {
                    VStack {
                        Image(systemName: "list.bullet.rectangle.portrait")
                            .foregroundColor(AppColor.brightOrange)
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
                Image(systemName: "wrench.and.screwdriver.fill")
                    .resizable()
                    .frame(width: 22.5, height: 20)
                    .foregroundColor(AppColor.brightOrange)
                Text(order.typeOfService.rawValue).font(.caption)
                Spacer()
            }
            .padding(.bottom, 8)
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .foregroundColor(AppColor.brightOrange)
                    .frame(width: 22.5, height: 20)
                Text(order.schedule.date()).font(.caption)
                Spacer()
            }
            .padding(.bottom, 5)
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .resizable()
                    .frame(width: 22.5, height: 20)
                    .foregroundColor(AppColor.brightOrange)
                Text(order.schedule.time()).font(.caption)
                Spacer()
                Button("Terima") {
                    isDetailBookingModalPresented.toggle()
                    self.selectedOrder = order
                }.padding()
                    .frame(width: 100, height: 30)
                    .background(AppColor.primaryColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .font(.caption)
            }
        }.onTapGesture {
            isDetailBookingModalPresented.toggle()
            self.selectedOrder = order
        }
        .sheet(isPresented: $isDetailBookingModalPresented) {
            if let id = Auth.auth().currentUser?.uid {
                viewModel.getBengkelOrders(bengkelId: id)
            }
        } content: {
            if let orderSelected = self.selectedOrder {
                DetailBooking(order: orderSelected)
            }
        }
    }

    private func currentBookingSection(order: [Order]) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(order, id: \.id) { order in
                    currentBookingCard(order: order)
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
                VStack(alignment: .leading) {
                    HStack {
                        Image("MotorIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(order.motor.brand.rawValue) \(order.motor.model)").font(.caption)
                    }
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(AppColor.brightOrange)
                        Text(order.typeOfService.rawValue).font(.caption)
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(AppColor.brightOrange)
                        Text(order.schedule.time()).font(.caption)
                    }
                    HStack {
                        Image("MekanikIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(AppColor.brightOrange)
                        if let mekanik = order.mekanik {
                            Text(mekanik.name).font(.caption)
                        } else {
                            Text("Tidak ada nama mekanik").font(.caption)
                        }
                    }
                }
            }
            HStack {
                Spacer()
                showStatus(status: order.status)
            }
        }.onTapGesture {
            isDetailBookingOnProgressPresented.toggle()
            self.selectedOrder = order
        }
        .sheet(isPresented: $isDetailBookingOnProgressPresented) {
            guard let id = Auth.auth().currentUser?.uid else { return }
            viewModel.getBengkelOrders(bengkelId: id)
        } content: {
            if let orderSelected = self.selectedOrder {
                DetailBooking(order: orderSelected)
            }
        }
    }

    @ViewBuilder private func showStatus(status: Order.Status) -> some View {
        if status == .scheduled {
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(AppColor.salmonOrange)
                .foregroundColor(AppColor.primaryColor)
                .cornerRadius(5)
        } else if status == .onProgress {
            Text("Dikerjakan")
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(Color.green)
                .foregroundColor(Color.systemGreen)
                .cornerRadius(5)
        } else if status == .done {
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.bold)
                .padding(5)
                .background(Color.systemBlue)
                .foregroundColor(Color.blue)
                .cornerRadius(5)
        }
    }
}

struct BookingTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        BookingTabItemView()
    }
}
