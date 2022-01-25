//
//  LoginView.swift
//  Moku
//
//  Created by Dicky Buwono on 23/01/22.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject var session = SessionService.shared
    @State var loginSuccess = false
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .frame(width: 170)
            Text("MOKU")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(AppColor.primaryColor)
                .padding(.bottom, 15)
            Text("The best App to maintain your motorcycle with ease")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 50)
                .foregroundColor(AppColor.grayText)
            Spacer()
            SignInWithAppleToFirebase({ response in
                if response == .success {
                   print("logged into Firebase through Apple!")
                    AppState.shared.viewID = UUID()
                    presentationMode.wrappedValue.dismiss()
                } else if response == .error {
                   print("error. Maybe the user cancelled or there's no internet")
                }
            })
                .frame(height: 55, alignment: .center)
                .padding(.horizontal)
            Button {
                presentationMode.wrappedValue.dismiss()
            }label: {
                Text("Masuk ke halaman utama")
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColor.orangeButton)
                    .foregroundColor(AppColor.primaryColor)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                    .padding(.horizontal)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
