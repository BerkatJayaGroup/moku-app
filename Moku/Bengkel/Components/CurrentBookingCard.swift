//
//  CurrentBookingCard.swift
//  Moku
//
//  Created by Mac-albert on 07/02/22.
//

import SwiftUI

struct CurrentBookingCard: View {

    @State var order: Order
    @State var customer: Customer?

    var body: some View {
        VStack(alignment: .leading) {
            if let customer = customer {
                Text(customer.name)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image("MotorIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
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
                            .aspectRatio(contentMode: .fit)
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
                Text(order.status.rawValue)
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(ButtonStatus.getColors(status: order.status))
                    .cornerRadius(5)
                    .foregroundColor(ButtonStatus.getFontColors(status: order.status) as? Color)
            }
        }
        .onAppear {
            getCustomerFromOrders(customerId: order.customerId)
        }
    }
}

// struct CurrentBookingCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentBookingCard()
//    }
// }

extension CurrentBookingCard {

    func getCustomerFromOrders(customerId: String) {
        CustomerRepository.shared.fetch(id: customerId) { customer in
            self.customer = customer
        }
    }
}
