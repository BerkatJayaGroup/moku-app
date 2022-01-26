//
//  EditMechanicViewModel.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

extension EditMechanic {
    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared
        @ObservedObject var sessionService = SessionService.shared
        @Published var nameFirst: String = ""
        @Published var photoUrlFirst: String = ""
        @Published var mechanic: Mekanik
        @Published var image: [UIImage] = []
        @Published var showImagePicker: Bool = false
        @Published var showActionSheet = false
        @Published var mechanicName: String
        @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary

        var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
        private var shouldDismissView = false {
            didSet {
                viewDismissalModePublisher.send(shouldDismissView)
            }
        }
        @Published var isLoading = false

        init(mechanic: Mekanik) {
            self.mechanic = mechanic
            self.mechanicName = mechanic.name
            self.nameFirst = mechanic.name
        }

        func removeMechanic() {
            guard let id = Auth.auth().currentUser?.uid else { return }
            bengkelRepository.removeMechanic(mechanic: mechanic, to: id)
        }

        func updateMechanic() {
            if case .bengkel(var bengkel) = sessionService.user {
                guard let index = bengkel.mekaniks.firstIndex(where: { $0.id == mechanic.id }) else { return }
                if let image = self.image.first {
                    StorageService.shared.upload(image: image,
                                                 path: "\(String(describing: bengkel.id))/mechanics/\(UUID().uuidString)") { url, _ in
                        guard let url = url?.absoluteString else { return }
                        bengkel.mekaniks[index] = Mekanik(name: self.mechanicName, photo: url)
                        self.bengkelRepository.update(bengkel: bengkel) {
                            self.isLoading = false
                            self.shouldDismissView = true
                        }
                    }
                } else {
                        bengkel.mekaniks[index] = Mekanik(name: mechanicName, photo: self.mechanic.photo)
                        bengkelRepository.update(bengkel: bengkel) {
                            self.isLoading = false
                            self.shouldDismissView = true
                        }
                }
            }
        }
    }
}
