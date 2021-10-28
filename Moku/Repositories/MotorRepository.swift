//
//  MotorRepository.swift
//  Moku
//
//  Created by Devin Winardi on 25/10/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class MotorRepository: ObservableObject {
    static let shared = MotorRepository()

    private let store = Firestore.firestore().collection("customer/rkJ4KBkeBAL0ibyiRaf8/motor")

    @Published var motors = [Motor]()

    private init() {
        fetch()
    }

    func fetch() {
        store.getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else {
                return
            }
            self.motors = RepositoryHelper.extractData(from: documents, type: Motor.self)
        }
    }
}
