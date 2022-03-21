//
//  PickRoleView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import Foundation
import FirebaseAuth
import SwiftUI

struct PickRoleView: View {
    //    @State var isNavigateToBengkelOnboarding = false
    @Environment(\.presentationMode) var presentationMode
    @State var motorSelected: Bool = false
    @State var bengkelSelected: Bool = false
    @State var isActive: Bool = false

    var btnBack: some View {
        Button {
          do {
            try Auth.auth().signOut()
          } catch {
            print("already logged out")
          }
          AppState.shared.viewID = UUID()
        } label: {
          HStack {
              Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
              Text("Kembali")
          }
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Button {
                        motorSelected = true
                        bengkelSelected = false
                    } label: {
                        HStack {
                            Image("iconMotor")
                                .resizable()
                                .frame(width: proxy.size.width * 0.25, height: proxy.size.width * 0.25)
                            Spacer()
                            Text("Pemilik Motor")
                                .font(.subheadline, weight: .semibold)
                                .foregroundColor(Color.black)
                        }
                    }
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.05)
                    .padding(50)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(motorSelected ? AppColor.primaryColor : AppColor.darkGray, lineWidth: 1))
                    Button {
                        motorSelected = false
                        bengkelSelected = true
                    } label: {
                        HStack {
                            Image("iconBengkel")
                                .resizable()
                                .frame(width: proxy.size.width * 0.25, height: proxy.size.width * 0.25)
                            Spacer()
                            Text("Pemilik Bengkel")
                                .font(.subheadline, weight: .semibold)
                                .foregroundColor(Color.black)
                        }
                    }
                    .frame(width: proxy.size.width * 0.6, height: proxy.size.height * 0.05)
                    .padding(50)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(bengkelSelected ? AppColor.primaryColor : AppColor.darkGray, lineWidth: 1))
                    Spacer()
                    NavigationLink(destination: getDestination(), isActive: $isActive) {
                        Button {
                            checkIsActive()
                        } label: {
                            Text("Lanjutkan").bold()
                        }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColor.primaryColor)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                            .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("Pilih Jenis Akun", displayMode: .inline)
            .navigationBarItems(leading: btnBack)
        }
    }

    func checkIsActive() {
        isActive = bengkelSelected || motorSelected
    }

    @ViewBuilder
    func getDestination() -> some View {
        if motorSelected {
            DaftarCustomer()
        } else {
            BengkelOwnerOnboardingView()
        }
    }
}

struct PickRoleView_Previews: PreviewProvider {
    static var previews: some View {
        PickRoleView()
          .previewDevice("iPhone 8")
    }
}
