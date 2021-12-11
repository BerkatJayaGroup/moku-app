//
//  BookingSeeAllView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 16/11/21.
//

import SwiftUI
import FirebaseAuth

struct BookingSeeAllView: View {
    @ObservedObject private var viewModel: BookingTabItemViewModel = .shared

    @State private var isDetailBookingModalPresented = false

    init() {
//        let navBarAppearance = UINavigationBar.appearance()
//        navBarAppearance.backgroundColor = .white
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
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
    }

    private func orderCards(order: Order) -> some View {
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
