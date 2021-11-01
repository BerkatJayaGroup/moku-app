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
                NavigationLink(destination: BengkelOwnerOnboardingView()) {
                    Text("Bengkel")
                }
                NavigationLink(destination: DaftarCustomer()) {
                    Text("Customer")
                }
            }
        }
    }

}
