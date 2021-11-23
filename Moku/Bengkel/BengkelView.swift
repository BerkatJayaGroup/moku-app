//
//  BengkelView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI
import Combine
import Foundation

struct BengkelView: View {

    var body: some View {
        TabView {
            BookingTabItemView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Booking")
                }
            PesananTabBengkelView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("Pesanan")
                }
            Text("Bengkel").tabItem {
                Image(systemName: "star")
                Text("Bengkel")
            }
        }
    }
}
