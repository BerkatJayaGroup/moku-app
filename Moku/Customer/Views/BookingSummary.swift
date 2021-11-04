//
//  BookingSummary.swift
//  Moku
//
//  Created by Dicky Buwono on 01/11/21.
//

import SwiftUI

struct BookingSummary: View {
    var body: some View {
        VStack {
            Text("Berkat Jaya Group")
                .font(.system(size: 20, weight: .semibold))
                .padding(5)
            Text("Jl. Sudirman 2 no 5, Jakarta Selatan, Kemang ")
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
                        Text("Motor")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Service Rutin")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Kamis, 7 Oktober 2021")
                            .font(.system(size: 13, weight: .semibold))
                        Text("12.00")
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
        BookingSummary()
    }
}
