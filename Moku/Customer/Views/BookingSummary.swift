//
//  BookingSummary.swift
//  Moku
//
//  Created by Dicky Buwono on 01/11/21.
//

import SwiftUI
import FirebaseFirestore
import Combine

extension Date {
    func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM y"
        return formatter.string(from: self)
    }

    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

extension BookingSummary {
    class ViewModel: ObservableObject {

        @Published private var order: Order

        @Published private var bengkel: Bengkel?

        @Published var docRef: DocumentReference?

        @ObservedObject var bengkelRepository: BengkelRepository = .shared

        init(order: Order) {
            self.order = order

            bengkelRepository.fetch(id: order.bengkelId) { bengkelData in
                self.bengkel = bengkelData
            }
        }

        var bengkelName: String {
            bengkel?.name ?? "Bengkel Name"
        }

        var address: String {
            bengkel?.address ?? "Bengkel Address"
        }

        var motor: String {
            order.motor.model
        }

        var jenisPerbaikan: String {
            order.typeOfService.rawValue
        }

        var date: String {
            order.schedule.date()
        }

        var time: String {
            order.schedule.time()
        }

        func placeOrder(completionHandler: ((DocumentReference) -> Void)? = nil) {
            OrderRepository.shared.add(order: order) { docRef in
                completionHandler?(docRef)
            }
        }
    }
}

struct BookingSummary: View {
    @StateObject private var viewModel: ViewModel

    @Binding var isRootActive: Bool
    @Binding var isHideTabBar: Bool

    init(order: Order, isRootActive: Binding<Bool>, isHideTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(order: order))
        _isRootActive = isRootActive
        _isHideTabBar = isHideTabBar
    }

    var body: some View {
        if let docRef = viewModel.docRef {
            BookingConfirmationView(orderId: docRef, bengkelName: viewModel.bengkelName, isRootActive: self.$isRootActive, isHideTabBar: self.$isHideTabBar)
        } else {
            VStack {
                VStack {
                    Text(viewModel.bengkelName)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(5)
                    Text(viewModel.address)
                        .font(.caption)
                        .foregroundColor(AppColor.darkGray)
                    Divider()
                        .padding(.vertical)
                    VStack(alignment: .leading) {
                        Text("Keterangan Booking")
                            .font(.system(size: 17, weight: .semibold))
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Motor")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Jenis Perbaikan")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Hari")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                                Text("Jam")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(AppColor.darkGray)
                            }.padding(.vertical)
                            Spacer(minLength: 1)
                            VStack(alignment: .leading, spacing: 20) {
                                Text(viewModel.motor)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(viewModel.jenisPerbaikan)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(viewModel.date)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(viewModel.time)
                                    .font(.system(size: 13, weight: .semibold))
                            }.padding(.vertical)
                        }
                    }
                    Spacer()
                }
                .padding(30)
                .navigationTitle("Booking Detail")
                .navigationBarTitleDisplayMode(.inline)

                Button {
                    viewModel.placeOrder { docRef in
                        viewModel.docRef = docRef
                    }
                } label: {
                Text("Konfirmasi Booking")
                    .frame(width: 310, height: 50)
                    .background(AppColor.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }
}
