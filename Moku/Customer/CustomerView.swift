//
//  CustomerView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI

struct CustomerView: View {
    @State var customer: Customer

    init(for customer: Customer) {
        _customer = State(wrappedValue: customer)
    }

    var body: some View {
        TabView {
            BengkelTabItem()
                .tabItem {
                    Image(systemName: "star")
                    Text("Bengkel")
                }
            Text("Booking View")
                .tabItem {
                    Image(systemName: "star")
                    Text("Booking")
                }
            GarasiTabItem()
                .tabItem {
                    Image(systemName: "star")
                    Text("Garasi")
                }
        }
    }
}

struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerView(for: .preview)
    }
}
