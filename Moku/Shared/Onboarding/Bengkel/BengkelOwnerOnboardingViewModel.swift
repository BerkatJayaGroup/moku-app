//
//  BengkelOwnerOnboardingViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 29/10/21.
//

import SwiftUI
import Combine
import GoogleMaps
import CoreLocation

extension BengkelOwnerOnboardingView {

    final class ViewModel: ObservableObject {
        // MARK: - Form Fields
        @Published var ownerName: String = ""
        @Published var bengkelName: String = ""
        @Published var location: Location?
        @Published var phoneNumber: String = ""

        // MARK: - View States
        @Published var isSettingDetail = false
        @Published var isSelectingLocation = false

        @Published var isSubmitting = false
        
        @Published var images: [UIImage] = []

        var address: String? {
            location?.address
        }

        var isFormValid: Bool {
            !ownerName.isEmpty && !bengkelName.isEmpty && !phoneNumber.isEmpty && location != nil && images != []
        }

        func openBengkelSetting() {
            validateForm()
            if isFormValid {
                isSettingDetail = true
            }
        }

        func selectLocation() {
            isSelectingLocation = true
        }

        func updateLocation(_ location: Location) {
            self.location = location
            if bengkelName.isEmpty {
                bengkelName = location.name ?? ""
            }
        }

        func validateForm() {
            isSubmitting = true
        }
    }
}
