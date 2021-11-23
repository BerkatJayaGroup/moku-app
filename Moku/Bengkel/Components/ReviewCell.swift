//
//  UlasanCell.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import SwiftUI

struct ReviewCell: View {
    @StateObject var viewModel: ViewModel
    
    init(order: Order){
        let viewModel = ViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let order = viewModel.order{
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
                    Text("order.schedule")
                    //                Text(order.schedule.formatted("EEEE, d MMM yyyy HH:mm"))
                        .font(.system(size: 13))
                    Spacer()
                    Text(order.status.rawValue)
                        .font(.system(size: 11))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2.5)
                        .background(Color(hex: "F8D8BF"))
                        .cornerRadius(4)
                        .foregroundColor(AppColor.primaryColor)
                }
            }
        }
        .padding()
    }
}

struct UlasanCell_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCell(order: Order(bengkelId: "1234", customerId: "12345", motor: Motor(brand: .honda, model: "Beat", cc: 110), typeOfService: .servisRutin, schedule: Date()))
            .previewLayout(.sizeThatFits)
    }
}
