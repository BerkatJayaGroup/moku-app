//
//  PromotionalBannerRepository.swift
//  Moku
//
//  Created by Christianto Budisaputra on 10/12/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

final class PromotionalBannerRepository: ObservableObject {
    static let shared = PromotionalBannerRepository()

    private let store = Firestore.firestore().collection("promotionalBanners")

    @Published var banners = [PromotionalBanner]()

    private init() {
        fetch()
    }

    func fetch() {
        store.getDocuments { snapshot, error in
            guard let documents = RepositoryHelper.extractDocuments(snapshot, error) else { return }
            self.banners = RepositoryHelper.extractData(from: documents, type: PromotionalBanner.self)
        }
    }
}
