//
//  BengkelRepository.swift
//  Moku
//
//  Created by Christianto Budisaputra on 14/10/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

// Final, biar ga bisa di extend
final class BengkelRepository: ObservableObject {
    // Shared Instance (Singleton)
    static let shared = BengkelRepository()

    // Firestore Setup
    private let store = Firestore.firestore().collection(Collection.bengkel)

    // MARK: Properties
    @Published var bengkel = [Bengkel]()

    // Initial Setup
    private init() {
        fetch()
    }

    // MARK: - CRUD Operations
    func fetch() {
        store.getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else { return }
            self.bengkel = RepositoryHelper.extractData(from: documents, type: Bengkel.self)
        }
    }

    func add(bengkel: Bengkel, completionHandler: ((DocumentReference) -> Void)? = nil) {
        do {
            let docRef = try store.addDocument(from: bengkel)
            completionHandler?(docRef)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }

    func remove(bengkel: Bengkel) {
        store.document(bengkel.id).delete()
    }

    func update(bengkel: Bengkel) {
        do {
            try store.document(bengkel.id).setData(from: bengkel, merge: true)
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }
}
