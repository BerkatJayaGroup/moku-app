//
//  BookingSummary.swift
//  Moku
//
//  Created by Dicky Buwono on 01/11/21.
//

import SwiftUI

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

        init(order: Order) {
            self.order = order
        }

        var bengkel: String {
            order.bengkel.name
        }

        var address: String {
            order.bengkel.address
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
    }
}

struct BookingSummary: View {
    @StateObject private var viewModel: ViewModel

    init(order: Order) {
        _viewModel = StateObject(wrappedValue: ViewModel(order: order))
    }

    var body: some View {
        VStack {
            Text(viewModel.bengkel)
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
            Button {

            } label: {
            Text("Konfirmasi Booking")
                .frame(width: 310, height: 50)
                .background(AppColor.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
        .padding(30)
        .navigationTitle("Booking Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BookingSummary_Previews: PreviewProvider {
    static var previews: some View {
        BookingSummary(order: .preview)
    }
}
