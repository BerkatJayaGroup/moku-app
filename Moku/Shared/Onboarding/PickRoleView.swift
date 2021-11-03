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

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DaftarCustomer()) {
                    HStack {
                        Image("pemilik-motor")
                        Text("Pemilik Motor")
                    }
                }.padding(50)
                    .border(AppColor.primaryColor)
                NavigationLink(destination: BengkelOwnerOnboardingView()) {
                    HStack {
                        Image("pemilik-bengkel")
                        Text("Pemilik Bengkel")
                    }
                }.padding(50)
                    .border(AppColor.primaryColor)
                Spacer()
            }
        }.navigationBarTitle("Pilih Jenis Akun", displayMode: .inline)
    }

}
