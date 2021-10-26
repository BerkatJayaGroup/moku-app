//
//  MotorcycleViewModel.swift
//  Moku
//
//  Created by Devin Winardi on 25/10/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import Combine

class MotorViewModel: ObservableObject {
    @ObservedObject private var repository: MotorRepository = .shared
    
    @Published var motors = [Motor]()
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = MotorViewModel()
    
    init() {
        repository.$motors
            .assign(to: \.motors, on: self)
            .store(in: &cancellables)
        print(motors.count)
    }
}
