//
//  OrderCardsSeeAll.swift
//  Moku
//
//  Created by Mac-albert on 23/01/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderCardsSeeAll: View {
    @ObservedObject private var viewModel: GarageTabViewModel = .shared
    @State private var isModalPresented = false
    var orderDetail: Order
    let dateFormatter = DateFormatter()
    init(order: Order) {
        orderDetail = order
    }
    var body: some View {
        HStack(spacing: 10) {
            if let photo = viewModel.bengkel?.photos.first {
                WebImage(url: URL(string: String(photo)))
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }
            else{
                Image("bengkel1")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 8){
                Text(viewModel.bengkel?.name ?? "Loading...")
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.bottom, 5)
                Text(Date.convertDateFormat(date: orderDetail.schedule, format: "EEEE, dd-MM-yyyy"))
                    .font(.system(size: 13, weight: .light))
                Text(orderDetail.motor.brand.rawValue + " " + orderDetail.motor.model)
                    .font(.system(size: 13, weight: .light))
                Text(orderDetail.typeOfService.rawValue)
                    .font(.system(size: 13, weight: .light))
                HStack{
                    Spacer()
                    Text(orderDetail.status.rawValue)
                        .font(.system(size: 11))
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2.5)
                        .background(getColors(status: orderDetail.status))
                        .cornerRadius(4)
                        .foregroundColor(getFontColors(status: orderDetail.status) as? Color)
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

