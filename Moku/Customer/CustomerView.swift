//
//  CustomerView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI

extension CustomerView {
    enum Tab {
        case bengkel, booking, garasi
    }
}

struct CustomerView: View {
    @State private var tabSelection: Tab = .bengkel

    var body: some View {
        TabView(selection: $tabSelection) {
            BengkelTabItem()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                    Text("Bengkel")
                }.tag(Tab.bengkel)
            BookingsTabItem()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Booking")
                }.tag(Tab.booking)
            GarasiTabItem()
                .tabItem {
                    Image(systemName: "bicycle")
                    Text("Garasi")
                }.tag(Tab.garasi)
        }
    }

    private var navigationBarTitle: String {
        switch tabSelection {
        case .bengkel: return ""
        case .booking: return "Bookings"
        case .garasi: return "Garasi"
        }
    }

    private var navigationBarIsHidden: Bool {
        tabSelection == .bengkel
    }
}
