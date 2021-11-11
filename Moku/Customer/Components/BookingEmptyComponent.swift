//
//  BookingEmptyComponent.swift
//  Moku
//
//  Created by Dicky Buwono on 09/11/21.
//

import SwiftUI

struct BookingEmptyComponent: View {
    @State var state: Bool
    var body: some View {
        if state == true {
            VStack {
                Image(systemName: "newspaper")
                    .font(.system(size: 100))
                    .foregroundColor(AppColor.darkGray)
                Text("Tidak ada Booking dalam tahap pengerjaan")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(AppColor.darkGray)
                    .multilineTextAlignment(.center)
                    .padding()
            }.padding(40)
        } else {
            VStack {
                Image(systemName: "newspaper")
                    .font(.system(size: 100))
                    .foregroundColor(AppColor.darkGray)
                VStack {
                    Text("Belum ada booking")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppColor.darkGray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 2)
                    Text("Segera lakukan Booking untuk melihat jadwal pesanan anda!")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(AppColor.darkGray)
                        .multilineTextAlignment(.center)
                }.padding(5)
            }.padding(40)
        }
    }
}

struct BookingEmptyComponent_Previews: PreviewProvider {
    static var previews: some View {
        BookingEmptyComponent(state: true)
    }
}
