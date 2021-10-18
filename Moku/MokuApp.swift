//
//  MokuApp.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Firebase

struct BengkelView: View {
    @State var bengkel: Bengkel

    init(from bengkel: Bengkel) {
        _bengkel = State(wrappedValue: bengkel)
    }

    var body: some View {
        Text("Bengkel View")
    }
}

struct CustomerView: View {
    @State var customer: Customer

    init(from customer: Customer) {
        _customer = State(wrappedValue: customer)
    }

    var body: some View {
        Text("\(customer.name) - \(customer.phoneNumber)")
    }
}

@main
struct MokuApp: App {
    @ObservedObject var session = SessionService.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let user = session.user {
                switch user {
                case let .bengkel(bengkel):
                     BengkelView(from: bengkel)
                case let .customer(customer):
                     CustomerView(from: customer)
                }
            } else {
                // Suruh Login...
                Text("Anda harus login.")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let customer = Customer(name: "Alpha", phoneNumber: "1234")
                            session.user = .customer(customer)
                        }
                    }
            }
        }
    }
}
