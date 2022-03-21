//
//  BookingComponentList.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookingComponentList: View {
    @State var customer: Customer?
    @State var bengkel: Bengkel?

    let order: Order

    init(order: Order) {
        self.order = order
        getCustomerFromOrders(customerId: order.customerId)
        getBengkelOrders(bengkelId: order.bengkelId)
    }

    var body: some View {
        HStack {
            if let photo = bengkel?.photos.first {
                WebImage(url: URL(string: photo))
                    .font(.system(size: 85))
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            } else {
                Image("number")
                    .font(.system(size: 85))
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(bengkel?.name ?? "")
                    .font(.system(size: 15, weight: .semibold))
                HStack(spacing: 5) {
                    VStack(alignment: .leading, spacing: 5) {
                        Image(systemName: "bicycle")
                            .font(.system(size: 13))
                            .foregroundColor(AppColor.primaryColor)
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.system(size: 13))
                            .foregroundColor(AppColor.primaryColor)
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 13))
                            .foregroundColor(AppColor.primaryColor)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(order.motor.brand.rawValue) " + "\(order.motor.model)")
                            .font(.system(size: 13))
                        Text("\(order.typeOfService.rawValue)")
                            .font(.system(size: 13))
                        Text("\(Date.convertDateFormat(date: order.schedule, format: "eeee, d MMMM YYYY - HH:mm"))")
                            .font(.system(size: 13))
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
            }
            .padding(.trailing, 5)
            .offset(x: -2)
        }
    }
}

struct BookingComponentList_Previews: PreviewProvider {
    static var previews: some View {
        BookingComponentList(order: .preview)
            .previewLayout(.sizeThatFits)
    }
}

extension BookingComponentList {

    func getBengkelOrders(bengkelId: String) {
        BengkelRepository.shared.fetch(id: bengkelId) { bengkel in
            self.bengkel = bengkel
        }
    }

    func getCustomerFromOrders(customerId: String) {
        CustomerRepository.shared.fetch(id: customerId) { customer in
            self.customer = customer
        }
    }
}
