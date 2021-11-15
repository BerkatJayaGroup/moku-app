//
//  PickRoleView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import Foundation
import SwiftUI

struct PickRoleView: View {

    //    @State var isNavigateToBengkelOnboarding = false
    @State var motorSelected: Bool = false
    @State var bengkelSelected: Bool = false

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Button(action: {motorSelected = true
                        bengkelSelected = false
                    }){
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(motorSelected ? AppColor.primaryColor : AppColor.darkGray)
                                .font(.system(size: proxy.size.width * 0.19), weight: .ultraLight)
                            Text("Pemilik Motor")
                                .font(.title3, weight: .semibold)
                                .foregroundColor(motorSelected ? AppColor.primaryColor : AppColor.darkGray)
                        }
                    }
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.05)
                    .padding(50)
                    .border(motorSelected ? AppColor.primaryColor : AppColor.darkGray, width: 1)
                    Button(action: {motorSelected = false
                        bengkelSelected = true
                    }){
                        HStack {
                            Image(systemName: "wrench.and.screwdriver")
                                .foregroundColor(bengkelSelected ? AppColor.primaryColor : AppColor.darkGray)
                                .font(.system(size: proxy.size.width * 0.15), weight: .ultraLight)
                            Text("Pemilik Bengkel")
                                .font(.title3, weight: .semibold)
                                .foregroundColor(bengkelSelected ? AppColor.primaryColor : AppColor.darkGray)
                        }
                    }
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.05)
                    .padding(50)
                    .border(bengkelSelected ? AppColor.primaryColor : AppColor.darkGray, width: 1)
                    Spacer()
                    NavigationLink(destination: getDestination()) {
                        Text("Lanjutkan")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background((bengkelSelected || motorSelected) ? AppColor.primaryColor : AppColor.darkGray)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                            .padding(.horizontal)
                    }
                }
            }.navigationBarTitle("Pilih Jenis Akun", displayMode: .inline)
        }
    }

    @ViewBuilder
    func getDestination() -> some View {
        if motorSelected {
            DaftarCustomer()
        } else {
            BengkelOwnerOnboardingView()
    }
}

struct PickRoleView_Previews: PreviewProvider {
    static var previews: some View {
        PickRoleView()
    }
}
