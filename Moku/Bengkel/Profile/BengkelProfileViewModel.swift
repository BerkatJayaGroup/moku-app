//
//  BengkelProfileViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 25/11/21.
//

import Foundation
import Combine
import SwiftUI
import FirebaseStorage

class BengkelProfileViewModel: ObservableObject {
    enum ActiveAlert: String, Identifiable {
        case delete, save

        var id: String { self.rawValue }
    }

    enum MediaSource: String, Identifiable {
        case camera, library

        var id: String { self.rawValue }
    }

    enum ActiveSheet: Identifiable {
        case bengkelLocation
        case mediaSource(source: MediaSource)

        var id: String {
            switch self {
            case .bengkelLocation:
                return "bengkelLocation"
            case .mediaSource(_):
                return "mediaSource"
            }
        }
    }

    @Published private var bengkel: Bengkel?

    @Published var isEditing = false
    @Published var isLoading = false
    @Published var isPresentingActionScheet = false
    @Published var isPresentingLibrary = false
    @Published var activeSheet: ActiveSheet?
    @Published var activeAlert: ActiveAlert?
    @Published var mediaSource: MediaSource?

    @Published var selectedPhoto: UIImage?
    @Published var selectedPhotoUrl: String?
    @Published var photosToUpload = [UIImage]()
    @Published var photosToRemove = [String]()
    @Published var photoToRemove: String?

    @Published var bengkelName = ""
    @Published var bengkelLocation: Location?
    @Published var bengkelAddress = ""
    @Published var bengkelPhoneNumber = ""

    private var subscriptions = Set<AnyCancellable>()

    private var initialBengkelState: Bengkel?

    var bengkelPhotos: [String] {
        bengkel?.photos ?? []
    }

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
        self.bengkelName = bengkel.name
        self.bengkelPhoneNumber = bengkel.phoneNumber
        self.bengkelAddress = bengkel.address

        applySubscriptions()
    }

    private func setup() {
        guard case .bengkel(let bengkel) = SessionService.shared.user else { return }
        self.bengkel = bengkel
    }

    func applySubscriptions() {
        $bengkelLocation.sink { location in
            guard let address = location?.address else { return }
            self.bengkelAddress = address
        }.store(in: &subscriptions)

        $isPresentingLibrary.sink { isPresenting in
            if !isPresenting {
                self.activeSheet = nil
            }
        }.store(in: &subscriptions)

        $activeSheet.sink { [self] sheet in
            if case .mediaSource(source: let source) = sheet, case .library = source {
                isPresentingLibrary = true
            }
        }.store(in: &subscriptions)
    }

    func toggleEditing() {
        isEditing.toggle()
    }

    func removePhoto() {
        guard let photoToRemove = photoToRemove,
              let index = bengkel?.photos.firstIndex(of: photoToRemove)
        else {
            return
        }
        photosToRemove.append(photoToRemove)
        bengkel?.photos.remove(at: index)
    }

    func updateLocation(_ location: Location) {
        self.bengkelLocation = location
    }

    func saveChanges(completionHandler: (() -> Void)? = nil) {
        isLoading = true
        var updatedBengkel = bengkel
        updatedBengkel?.name = bengkelName
        updatedBengkel?.phoneNumber = bengkelPhoneNumber
        updatedBengkel?.photos = bengkelPhotos
        if let bengkelLocation = bengkelLocation {
            updatedBengkel?.location = bengkelLocation
        }

        guard let updatedBengkel = updatedBengkel else { return }
        BengkelRepository.shared.update(bengkel: updatedBengkel) { [self] in
            removeAndUploadPhotosIfNeeded(
                photosToUpload: photosToUpload,
                photosToRemove: photosToRemove) {
                    isLoading = false
                    completionHandler?()
                }
        }
    }

    func removeAndUploadPhotosIfNeeded(photosToUpload: [UIImage], photosToRemove: [String], completionHandler: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        photosToUpload.forEach { photo in
            dispatchGroup.enter()
            let path = "photos/" + UUID().uuidString
            StorageService.shared.upload(image: photo, path: path) { url, _ in
                guard let url = url?.absoluteString, let bengkel = self.bengkel else { return }
                BengkelRepository.shared.appendBengkelPhoto(photoUrl: url, to: bengkel.id) { _ in
                    dispatchGroup.leave()
                }
            }
        }
        photosToRemove.forEach { url in
            dispatchGroup.enter()
            StorageService.shared.delete(url: url) {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completionHandler?()
        }
    }

    func fetch() {
        guard let bengkel = bengkel else { return }
        BengkelRepository.shared.fetch(id: bengkel.id) { bengkel in
            self.bengkel = bengkel
        }
    }
}
