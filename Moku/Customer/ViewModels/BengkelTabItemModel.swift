//
//  BengkelTabItemModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Combine

extension BengkelTabItem {
    class ViewModel: ObservableObject {
        @Published var currentLocation = "Loading..."
        @Published var selectedMotor: Motor?

        @Published var isCustomer = false
        var customerMotors = [Motor]()

        private var subscriptions = Set<AnyCancellable>()

        init() {
            getMotors()
            getLocation()
        }

        private func getMotors() {
            SessionService.shared.$user.sink { [self] user in
                switch user {
                case .customer(let customer):
                    isCustomer = true
                    if let motors = customer.motors {
                        customerMotors = motors
                    }
                    if let motor = customerMotors.first {
                        selectedMotor = motor
                    }
                default:
                    isCustomer = false
                }
            }.store(in: &subscriptions)
        }

        private func getLocation() {
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocode(coordinate: coordinate) { location in
                    self.currentLocation = location
                }
            }.store(in: &subscriptions)
        }
    }
}
