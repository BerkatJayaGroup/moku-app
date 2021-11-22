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
    
    @Published var filteredOrdersStatus = [Order]()

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

    func fetchId(id: String, completionHandler: ((Order) -> Void)? = nil) {
        store.document(id).getDocument { document, error in
            do {
                if let data = try document?.data(as: Order.self) {
                    completionHandler?(data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func fetchOrderHistory(customerId: String, completionHandler: (([Order]) -> Void)? = nil) {
        store.whereField("customerId", isEqualTo: customerId).getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else { return }
            let customerOrders = RepositoryHelper.extractData(from: documents, type: Order.self)
            completionHandler?(customerOrders)
        }
    }

    func fetchBengkelOrder(bengkelId: String, completionHandler: (([Order]) -> Void)? = nil) {
        store.whereField("bengkelId", isEqualTo: bengkelId).addSnapshotListener { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else { return }
            let bengkelOrders = RepositoryHelper.extractData(from: documents, type: Order.self)
            completionHandler?(bengkelOrders)
        }
    }
    
    func fetch(bengkelId: String, completionHandler: (([Order]) -> Void)? = nil) {
        store.whereField("bengkelId", isEqualTo: bengkelId).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting stories: \(error.localizedDescription)")
                return
            }

            let order = snapshot?.documents.compactMap { document in
                try? document.data(as: Order.self)
            } ?? []

            DispatchQueue.global(qos: .background).async {
                self.filteredOrders = order
                completionHandler?(order)
            }
        }
    }

    func fetch(_ customerId: String) {
            store.whereField("customerId", isEqualTo: customerId).addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting stories: \(error.localizedDescription)")
                    return
                }
                let order = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Order.self
                    )
                } ?? []
                DispatchQueue.main.async {
                    self.filteredOrdersStatus = order
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

    func updateStatus(order: Order, completioHandler: ((Error?) -> Void)? = nil) {
        do {
            try store.document(order.id).setData(from: order, merge: true) { error in
                completioHandler?(error)
            }
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }
    
    func addMekanik(orderId: String, mechanicsName: String){
        store
            .document(orderId)
            .updateData(
                ["mechanicName" : mechanicsName]
            )
    }
}
