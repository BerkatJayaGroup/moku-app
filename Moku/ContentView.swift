//
//  ContentView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    private let store = Firestore.firestore()
    init () {
        var bengkel = Bengkel(name: "BJG", phoneNumber: "1234")
        let review = Review(user: "Jin", ratings: 4, comment: "good", timestamp: Date())
        bengkel.reviews.append(review)
        //        do {
        //            _ = try store.collection("bengkel").addDocument(from: bengkel)
        //        } catch {
        //            fatalError("Unable to add bengkel: \(error.localizedDescription).")
        //        }
        
        //        let order = Order(bengkel: "BJG", customer: <#T##Customer#>, motor: <#T##Motor#>, typeOfService: <#T##Order.Service#>, schedule: <#T##Date#>)
        //
        let customer = Customer(name: "Devin-Test", phoneNumber: "1234", motors: [Motor(brand: .honda, model: "bit", cc: 110)])
        //        do {
        //            _ = try store.collection("customer").addDocument(from: customer)
        //        } catch {
        //            fatalError("Unable to add bengkel: \(error.localizedDescription).")
        //        }
        let order = Order(bengkel: bengkel, customer: customer, motor: Motor(brand: .honda, model: "bit", cc: 110), typeOfService: .checkup, schedule: Date())
        do {
            _ = try store.collection("order").addDocument(from: order)
        } catch {
            fatalError("Unable to add bengkel: \(error.localizedDescription).")
        }
    }
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
