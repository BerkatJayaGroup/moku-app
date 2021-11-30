//
//  ServiceInformationViewModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 26/11/21.
//

import SwiftUI
import Combine
import SwiftUIX

class FinishBookingViewModel: ObservableObject {
    @Published var spareParts: [String] = []
    @Published var notes = ""
    @Published var billPhotos: [String] = []
    @Published var isSubmitting = false
    
    @Published var order: Order
    
    init(order: Order) {
        self.order = order
    }

    var isFormValid: Bool {
        !spareParts.isEmpty && !notes.isEmpty && !notes.isEmpty
    }

}
