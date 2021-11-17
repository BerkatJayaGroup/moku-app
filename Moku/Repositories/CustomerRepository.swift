//
//  Customer.swift
//  Moku
//
//  Created by Mac-albert on 14/10/21.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CustomerRepository: ObservableObject {
    static let shared = CustomerRepository()

    private let store = Firestore.firestore().collection(Collection.customer)

    @Published var customer = [Customer]()

    private init() {
        fetch()
    }

    func fetch() {
        store.getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else {
                return
            }
            self.customer = RepositoryHelper.extractData(from: documents, type: Customer.self)
        }
    }

    func fetch(id: String, completionHandler: ((Customer) -> Void)? = nil) {
        store.document(id).getDocument { document, error in
            do {
                if let data = try document?.data(as: Customer.self) {
                    completionHandler?(data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func add(customer: Customer, completionHandler: ((DocumentReference) -> Void)? = nil) {
        if let id = Auth.auth().currentUser?.uid {
            let docRef = store.document(id)
            do {
                try docRef.setData(from: customer)
                completionHandler?(docRef)
            } catch {
                RepositoryHelper.handleParsingError(error)
            }
        }
    }

    func remove(customer: Customer) {
        store.document(customer.id).delete()
    }

    func update(customer: Customer, completionHandler: ((Customer) -> Void)? = nil) {
        do {
            try store.document(customer.id).setData(from: customer, merge: true)
            fetch(id: customer.id) { updatedCustomer in
                completionHandler?(updatedCustomer)
            }
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }
}
