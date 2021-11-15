//
//  BookingComponentList.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import SwiftUI

struct BookingComponentList: View {
    let order: Order
    init(order: Order) {
        self.order = order
    }
    var body: some View {
        HStack {
            Image(systemName: "number")
                .font(.system(size: 85))
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 5) {
                Text("Berkat Jaya Motor")
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
