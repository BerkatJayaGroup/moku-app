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
            SignInWithAppleToFirebase({ response in
                if response == .success {
                   print("logged into Firebase through Apple!")
                    @EnvironmentObject var appState: AppState
                    AppState.shared.viewID = UUID()
                    presentationMode.wrappedValue.dismiss()
                } else if response == .error {
                   print("error. Maybe the user cancelled or there's no internet")
                }
            })
                .frame(height: 50, alignment: .center)
                .padding(.horizontal)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
