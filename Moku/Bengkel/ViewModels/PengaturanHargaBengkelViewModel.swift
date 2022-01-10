//
//  PengaturanHargaBengkelViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 22/11/21.
//

import SwiftUI
import SwiftUIX

class PengaturanHargaBengkelViewModel: ObservableObject {
    @Published var minPrice = ""
    @Published var maxPrice = ""

    @Published var isSubmitting = false
    @Published var isLoading = false
    @State var canSubmit = false

    var isFormValid: Bool {
        !minPrice.isEmpty && !maxPrice.isEmpty
    }

    func validateForm() {
        isSubmitting = true
        if isFormValid {
            canSubmit = true
        }
    }

    func createBengkel(bengkelOwnerFormViewModel: BengkelOwnerOnboardingView.ViewModel, pengaturanBengkelForm: PengaturanBengkel) {
        guard let location = bengkelOwnerFormViewModel.location else { return }

        isLoading = true
        let calendar = Calendar.current
        let openTime = calendar.component(.hour, from: pengaturanBengkelForm.openTime)
        let closeTime = calendar.component(.hour, from: pengaturanBengkelForm.closeTime)

        NotificationService.shared.getToken { token in
            var bengkelBaru = Bengkel(
                owner: Bengkel.Owner(name: bengkelOwnerFormViewModel.ownerName, phoneNumber: bengkelOwnerFormViewModel.phoneNumber, email: ""),
                name: bengkelOwnerFormViewModel.bengkelName,
                phoneNumber: bengkelOwnerFormViewModel.phoneNumber,
                location: location,
                operationalHours: Bengkel.OperationalHours(open: openTime, close: closeTime),
                operationalDays: pengaturanBengkelForm.daySelected,
                minPrice: self.minPrice,
                maxPrice: self.maxPrice,
                fcmToken: token
            )

            for brand in pengaturanBengkelForm.selectedBrand {
                bengkelBaru.brands.insert(brand)
            }

            BengkelRepository.shared.add(bengkel: bengkelBaru) { docRef in
                let bengkelId = docRef.documentID

                DispatchQueue.global(qos: .background).async {
                    self.uploadMedia(bengkelId: bengkelId, images: bengkelOwnerFormViewModel.images, mechanics: pengaturanBengkelForm.mechanics) {
                        docRef.getDocument { snapshot, _ in
                            guard let bengkel = try? snapshot?.data(as: Bengkel.self) else { return }
                            DispatchQueue.main.async {
                                SessionService.shared.user = .bengkel(bengkel)
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func uploadMedia(bengkelId: String, images: [UIImage], mechanics: [CalonMekanik], completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        mechanics.forEach { mechanic in
            dispatchGroup.enter()
            guard let photo = mechanic.photo else { return }
            var newMechanic = Mekanik(name: mechanic.name)
            let path = "mechanics/" + newMechanic.id

            StorageService.shared.upload(image: photo, path: path) { url, _ in
                guard let url = url?.absoluteString else { return }
                newMechanic.photo = url
                BengkelRepository.shared.appendMechanic(mechanic: newMechanic, to: bengkelId) { _ in
                    dispatchGroup.leave()
                }
            }
        }
        images.forEach { image in
            dispatchGroup.enter()
            let path = "photos/" + UUID().uuidString
            StorageService.shared.upload(image: image, path: path) { url, _ in
                guard let url = url?.absoluteString else { return }
                BengkelRepository.shared.appendBengkelPhoto(photoUrl: url, to: bengkelId) { _ in
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
}
