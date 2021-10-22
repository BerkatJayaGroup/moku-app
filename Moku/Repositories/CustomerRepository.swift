//
//  Customer.swift
//  Moku
//
//  Created by Mac-albert on 14/10/21.
//

import Combine
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

    func add(customer: Customer) {
        do {
            _ = try store.addDocument(from: customer)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }

    func remove(customer: Customer) {
        store.document(customer.id).delete()
    }

    func update(customer: Customer) {
        do {
            try store.document(customer.id).setData(from: customer, merge: true)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }

}
