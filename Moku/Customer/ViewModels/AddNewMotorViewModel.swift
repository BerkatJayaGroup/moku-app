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
    @Published var motors: [Motor]?
    @Published var isEditing    = false
    @Published var show         = false
    @Published var plat         = ""
    @Published var masaBerlaku  = ""
    @Published var tahunBeli    = ""
    init(motor: Motor?, isEditing: Bool = false, motorBefore: Motor?, motors: [Motor]?) {
        self.motor          = motor
        self.isEditing      = isEditing
        self.motorBefore    = motorBefore
        self.motors         = motors

      if isEditing {
        plat = motorBefore?.licensePlate ?? ""
        tahunBeli = motorBefore?.year ?? ""
      }
    }
    func remove(completionHandler: (() -> Void)? = nil) {
        guard let motorID = motor?.id else { return }
        garageTabViewModel.removeMotor(motorID: motorID, motors: motors)
        completionHandler?()
    }
    func add(completionHandler: (() -> Void)? = nil) {
        guard !isEditing, let motor = motor else { return }
        motor.id = UUID().uuidString
        motor.licensePlate = plat
        motor.year = tahunBeli
        garageTabViewModel.addNew(motor: motor)
        completionHandler?()
    }
    func update(motorUpdate: Motor, completionHandler: (() -> Void)? = nil) {
        guard let motorID = motorBefore?.id else { return }
        plat = motorBefore?.licensePlate ?? ""
        motorUpdate.licensePlate = plat
        motorUpdate.year = tahunBeli
        garageTabViewModel.updateMotor(motorID: motorID, updatedMotor: motorUpdate, motors: motors)
        completionHandler?()
    }
}
