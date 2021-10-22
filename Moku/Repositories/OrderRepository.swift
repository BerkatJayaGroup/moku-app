//
//  OrderRepository.swift
//  Moku
//
//  Created by Christianto Budisaputra on 14/10/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

// Final, biar ga bisa di extend
final class OrderRepository: ObservableObject {
    // Shared Instance (Singleton)
    static let shared = OrderRepository()

    // Firestore Setup
    private let store = Firestore.firestore().collection(Collection.order)

    // MARK: Properties
    @Published var orders = [Order]()

    // Initial Setup
    private init() {
        fetch()
    }

    // MARK: - CRUD Operations
    func fetch() {
        store.getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else { return }
            self.orders = RepositoryHelper.extractData(from: documents, type: Order.self)
        }
    }

    func add(order: Order) {
        do {
            _ = try store.addDocument(from: order)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }

    func remove(order: Order) {
        store.document(order.id).delete()
    }

    func update(order: Order) {
        do {
            try store.document(order.id).setData(from: order, merge: true)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }
}