//
//  OrderRepository.swift
//  Moku
//
//  Created by Christianto Budisaputra on 14/10/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// Final, biar ga bisa di extend
final class OrderRepository: ObservableObject {
    typealias CompletionHandler = (DocumentReference) -> Void

    // Shared Instance (Singleton)
    static let shared = OrderRepository()

    // Firestore Setup
    private let store = Firestore.firestore().collection(Collection.order)

    // MARK: Properties
    @Published var orders = [Order]()
    @Published var filteredOrders = [Order]()

    @Published var customerOrders = [Order]()

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

    func fetch<T: Codable>(docRef: DocumentReference, completionHandler: ((T) -> Void)? = nil) {
        docRef.addSnapshotListener { document, error in
            do {
                if let data = try document?.data(as: T.self) {
                    completionHandler?(data)
                }
            } catch {
                print(error.localizedDescription)
            }

        }

    }

    func fetch(_ bengkelId: String) {
        store.whereField("bengkelId", isEqualTo: bengkelId).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting stories: \(error.localizedDescription)")
                return
            }

            let order = snapshot?.documents.compactMap { document in
                try? document.data(as: Order.self)
            } ?? []

            DispatchQueue.global(qos: .background).async {
                self.filteredOrders = order
            }
        }
    }

    func add(order: Order, completionHandler: CompletionHandler? = nil) {
        do {
            let ref = try store.addDocument(from: order) { error in
                // Unresolved Error
                if let error = error {
                    print("Unresolved error: Unable to place the order for \(order.schedule.date())", error.localizedDescription)
                }
            }
            completionHandler?(ref)
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
