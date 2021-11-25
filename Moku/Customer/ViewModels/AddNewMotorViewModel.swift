//
//  AddNewMotorViewModel.swift
//  Moku
//
//  Created by Dicky Buwono on 22/11/21.
//

import Foundation
import Combine
import SwiftUI

class AddNewMotorViewModel: ObservableObject {
    @ObservedObject private var garageTabViewModel = GarageTabViewModel.shared
    @Published var motor: Motor?
    @Published var motorBefore: Motor?
    @Published var isEditing    = false
    @Published var show         = false
    @Published var plat         = ""
    @Published var masaBerlaku  = ""
    @Published var tahunBeli    = ""
    init(motor: Motor?, isEditing: Bool = false, motorBefore: Motor?) {
        self.motor          = motor
        self.isEditing      = isEditing
        self.motorBefore    = motorBefore
    }
    func remove() {
        guard let motorID = motor?.id else { return }
        garageTabViewModel.removeMotor(motorID: motorID)
    }
    func add() {
        guard !isEditing, let motor = motor else { return }
        motor.licensePlate = plat
        motor.year = tahunBeli
        garageTabViewModel.addNew(motor: motor)
    }
    func update(motorUpdate: Motor) {
        guard let motorID = motorBefore?.id else { return }
        motorUpdate.licensePlate = plat
        motorUpdate.year = tahunBeli
        garageTabViewModel.updateMotor(motorID: motorID, updatedMotor: motorUpdate)
    }
}
