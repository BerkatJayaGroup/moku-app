//
//  BookingSeeAllView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 16/11/21.
//

import SwiftUI
import FirebaseAuth

struct BookingSeeAllView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject private var viewModel: BookingTabItemViewModel = .shared

    @State private var isDetailBookingModalPresented = false

    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    if let order = viewModel.bengkelOrders {
                        let newOrder = order.filter { order in
                            return order.status == .waitingConfirmation
                        }
                        ForEach(newOrder, id: \.id) { order in
                            orderCards(order: order).padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                                .padding(.top)
                                .padding(.horizontal)
                        }
                    } else {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
            .navigationBarTitle("Booking Masuk", displayMode: .inline)
            .navigationBarItems(leading: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.backward")
                    Text("Kembali")
                }
                .foregroundColor(.white)
            })
        }
        .navigationBarHidden(true)
    }

    private func orderCards(order: Order) -> some View {
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
                    .frame(width: 22.5, height: 20)
                    .foregroundColor(AppColor.brightOrange)
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
                }.padding()
                    .frame(width: 100, height: 30)
                    .background(AppColor.primaryColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .font(.caption)
            }
            .padding(.bottom, 5)
        }.onTapGesture {
            isDetailBookingModalPresented.toggle()
        }
        .sheet(isPresented: $isDetailBookingModalPresented) {
            guard let id = Auth.auth().currentUser?.uid else { return }
            viewModel.getBengkelOrders(bengkelId: id)
        } content: {
            DetailBooking(order: order)
        }
    }
}

struct BookingSeeAllView_Previews: PreviewProvider {
    static var previews: some View {
        BookingSeeAllView()
    }
}
