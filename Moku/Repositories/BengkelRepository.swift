//
//  BengkelRepository.swift
//  Moku
//
//  Created by Christianto Budisaputra on 14/10/21.
//

import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

// Final, biar ga bisa di extend
final class BengkelRepository: ObservableObject {
    // Shared Instance (Singleton)
    static let shared = BengkelRepository()

    // Firestore Setup
    private let store = Firestore.firestore().collection(Collection.bengkel)

    // MARK: Properties
    @Published var bengkel = [Bengkel]() {
        didSet {
            bengkel.forEach { bengkel in
                print("lmao", bengkel.name)
            }
        }
    }

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

    func fetch(id: String, completionHandler: ((Bengkel) -> Void)? = nil) {
        store.document(id).getDocument { document, error in
            do {
                if let data = try document?.data(as: Bengkel.self) {
                    completionHandler?(data)
                }
            } catch {
                print(error.localizedDescription)
            }
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

    func addRating(bengkelId: String, review: Review) {
        var reviewDict: [String: Any] = [
            "rating": review.rating,
            "timestamp": Date(),
            "user": review.user
        ]

        if let comment = review.comment {
            reviewDict["comment"] = comment
        }

        store
            .document(bengkelId)
            .updateData(
                ["reviews": FieldValue.arrayUnion([reviewDict])]
            )
    }

    func getMechanics(bengkelId: String) {

    }
}
