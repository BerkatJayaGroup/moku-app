//
//  UlasanCell.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import SwiftUI

struct ReviewCell: View {
    @StateObject var viewModel: ViewModel

    init(order: Order) {
        let viewModel = ViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let order = viewModel.order {
                if let customer = viewModel.customer {
                    Text(customer.name)
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                }
                Text(order.motor.model)
                    .font(.system(size: 13))
                Text(order.typeOfService.rawValue)
                    .font(.system(size: 13))
                HStack {
                    //                    Text("order.schedule")
                    Text(Date.convertDateFormat(date: order.schedule, format: "EEEE, d MMM yyyy HH:mm"))
                        .font(.system(size: 13))
                    Spacer()
                    Text(order.status.rawValue)
                        .font(.system(size: 11))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2.5)
                        .background(getColors(status: order.status))
                        .cornerRadius(4)
                        .foregroundColor(getFontColors(status: order.status) as? Color)
                }
            }
        }
        .padding()
        .border(Color(hex: "979797"), width: 1, cornerRadius: 6)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
    }

    func getColors(status: Order.Status) -> some View {
        switch status {
        case .scheduled: return Color(hex: "F8D8BF")
        case .rejected: return Color(hex: "FFBDBD")
        case .done: return Color(hex: "DCDCDC")
        default: return Color(hex: "F8D8BF")
        }
    }

    func getFontColors(status: Order.Status) -> some View {
        switch status {
        case .scheduled:
            return AppColor.primaryColor
        case .rejected:
            return Color.red
        case .done:
            return Color(hex: "686868")
        default:
            return AppColor.primaryColor
        }
    }
}

struct UlasanCell_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCell(order: Order(bengkelId: "1234", customerId: "12345", motor: Motor(brand: .honda, model: "Beat", cc: 110), typeOfService: .servisRutin, schedule: Date()))
            .previewLayout(.sizeThatFits)
    }
}
