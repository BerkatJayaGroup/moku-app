//
//  GarasiTabItem.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 09/11/21.
//

import SwiftUI

struct MotorCard: View {
    @State var motor: Motor
    @State var isEditingModalShown = false
    var body: some View {
        VStack {
            HStack {
                Text("\(motor.brand.rawValue) \(motor.model)")
                    .font(.system(size: 17, weight: .semibold))
                    .fixedSize(horizontal: true, vertical: false)
                Spacer()
                Button {
                    isEditingModalShown = true
                } label: {
                    Text("Sunting Motor").foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 13, weight: .semibold))
                        .fixedSize(horizontal: true, vertical: false)
                }
                .sheet(isPresented: $isEditingModalShown) {
                    AddNewMotor(motor: motor, isEditing: true, motorBefore: motor)
                }
            }.padding(.bottom, 15)
            Image("MotorIllustration")
                .padding(.bottom, 15)
            HStack {
                VStack(alignment: .leading) {
                    Text("Plat Nomor")
                        .font(.system(size: 13, weight: .regular))
                    Text("Tahun")
                        .font(.system(size: 13, weight: .regular))
                    Text("Servis Selanjutnya")
                        .font(.system(size: 13, weight: .regular))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(motor.licensePlate ?? "")
                        .font(.system(size: 13, weight: .semibold))
                    Text(motor.year ?? "")
                        .font(.system(size: 13, weight: .semibold))
                    Text("01-01-2022")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
            .padding()
            .background(AppColor.lightGray)
            .cornerRadius(9)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
    }
}

struct GarasiTabItem: View {
    @State private var index = 0
    @State private var isProfileModalPresented = false
    @State private var isAddMotorModalPresented = false
    @State private var newMotorSheet: Bool = false
    @State private var isSuntingModalPresented = false
    @ObservedObject private var viewModel: GarageTabViewModel = .shared
    var body: some View {
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(AppColor.primaryColor)
                    .ignoresSafeArea()
                    .frame(height: 0)
                ScrollView {
                    profileSection()
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        .padding(.horizontal)
                        .padding(.top)
                    motorSection()
                        .padding(.bottom, -20)
                    Divider()
                        .padding(.horizontal)
                    Text("Riwayat Servis")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                    serviceHistorySection().padding(10)
                }
            }
    }
    private func profileSection() -> some View {
        HStack {
            if let customer = viewModel.customer {
                Text(customer.name)
                    .font(.system(size: 15, weight: .regular))
                Spacer()
                NavigationLink(destination: EditProfileModal(customer: customer)){
                    Text("Profil")
                        .foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 13, weight: .semibold))
                }
            } else {
                Text("Loading...")
            }
        }.padding(10)
    }
    @ViewBuilder
    private func motorSection() -> some View {
        VStack {
            if !viewModel.customerMotors.isEmpty {
                PagingView(index: $index.animation(), maxIndex: viewModel.customerMotors.count) {
                    ForEach(viewModel.customerMotors) { motor in
                        MotorCard(motor: motor)
                            .padding(.horizontal)
                    }
                    VStack {
                        HStack{
                            Text("                                           ")
                                .font(.system(size: 17, weight: .semibold))
                                .backgroundColor(AppColor.lightGray)
                                .cornerRadius(10)
                                .foregroundColor(.clear)
                            Spacer()
                        }
                        Image("MotorIllustration").padding()
                        Button {
                            newMotorSheet.toggle()
                        } label: {
                            HStack{
                                Image(systemName: "plus")
                                Text ("Tambah Motor Baru")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColor.primaryColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal, .large)
                        .sheet(isPresented: $newMotorSheet) {
                            AddNewMotor(isEditing: false)
                                .navigationTitle("Sunting Motor")
                        }
                    }
                    .frame(height: 280)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    .padding(.horizontal)
                }
                .aspectRatio(3/3, contentMode: .fit)
            }
        }
    }
    private func serviceHistorySection() -> some View {
        VStack {
            if viewModel.customerOrders.isEmpty {
                Text("Belum ada riwayat servis")
            } else {
                ForEach(viewModel.customerOrders, id: \.id) { order in
                    OrderCards(order: order).background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        .padding(.horizontal)
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
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.bengkel?.name ?? "Loading...")
                .font(.system(size: 15, weight: .semibold))
                .padding(.bottom, 5)
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "bicycle")
                            .foregroundColor(AppColor.primaryColor)
                            .font(.system(size: 13))
                        Text(orderDetail.motor.brand.rawValue)
                            .font(.system(size: 13, weight: .regular))
                    }.padding(.bottom, 5)
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundColor(AppColor.primaryColor)
                            .font(.system(size: 13))
                        Text(orderDetail.typeOfService.rawValue)
                            .font(.system(size: 13, weight: .regular))
                    }
                }
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(AppColor.primaryColor)
                            .font(.system(size: 13))
                        Text(Date.convertDateFormat(date: orderDetail.schedule, format: "dd-MM-yyyy"))
                            .font(.system(size: 13, weight: .regular))
                    }.padding(.bottom, 5)
                    HStack {
                        Image(systemName: "wrench.fill")
                            .foregroundColor(AppColor.primaryColor)
                            .font(.system(size: 13))
                        Text(orderDetail.mekanik?.name ?? "Loading...")
                            .font(.system(size: 13, weight: .regular))
                    }
                }
            }
        }
        .padding()
        .onTapGesture {
            isModalPresented.toggle()
        }.sheet(isPresented: $isModalPresented) {
            if let bengkelDetail = viewModel.bengkel {
                OrderHistoryDetailModal(bengkel: bengkelDetail, order: orderDetail)
            }
        }.onAppear {
            viewModel.getBengkelFromOrder(bengkelId: orderDetail.bengkelId)
        }
    }
}

struct GarasiTabItem_Previews: PreviewProvider {
    static var previews: some View {
        GarasiTabItem()
    }
}
