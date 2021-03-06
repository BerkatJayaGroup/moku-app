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

    func fetch(id: String, completionHandler: ((Bengkel) -> Void)? = nil) {
        store.document(id).getDocument { document, _ in
            guard let workshop: Bengkel = try? document?.data(as: Bengkel.self) else { return }
            completionHandler?(workshop)
        }
    }

    func add(bengkel: Bengkel, completionHandler: ((DocumentReference) -> Void)? = nil) {
        if let id = Auth.auth().currentUser?.uid {
            let docRef = store.document(id)
            do {
                try docRef.setData(from: bengkel)
                completionHandler?(docRef)
            } catch {
                RepositoryHelper.handleParsingError(error)
            }
        }
    }

    func remove(bengkel: Bengkel) {
        store.document(bengkel.id).delete()
    }

    func update(bengkel: Bengkel, completionHandler: (() -> Void)? = nil) {
        do {
            try store.document(bengkel.id).setData(from: bengkel, merge: true) { _ in
                completionHandler?()
            }
        } catch {
            RepositoryHelper.handleParsingError(error)
        }
    }

    func appendMechanic(mechanic: Mekanik, to bengkelId: String, completion: ((Error?) -> Void)? = nil) {
        guard let photoUrl = mechanic.photo else { return }
        let mechanic: [String: Any] = [
            "id": mechanic.id,
            "name": mechanic.name,
            "photo": photoUrl
        ]
        store.document(bengkelId).updateData(
            ["mekaniks": FieldValue.arrayUnion([mechanic])],
            completion: completion
        )
    }

    func removeMechanic(mechanic: Mekanik, to bengkelId: String, completion: ((Error?) -> Void)? = nil) {
        var mechanicDict: [String: Any] = [
            "id": mechanic.id,
            "name": mechanic.name
        ]
        if let photo = mechanic.photo {
            mechanicDict["photo"] = photo
        }
        store.document(bengkelId).updateData(
            ["mekaniks": FieldValue.arrayRemove([mechanicDict])]
        )
    }

    func appendBengkelPhoto(photoUrl: String, to bengkelId: String, completion: ((Error?) -> Void)? = nil) {
        store.document(bengkelId).updateData(
            ["photos": FieldValue.arrayUnion([photoUrl])],
            completion: completion
        )
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
