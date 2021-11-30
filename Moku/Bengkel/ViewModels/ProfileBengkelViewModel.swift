//
//  ProfileBengkelViewModel.swift
//  Moku
//
//  Created by Mac-albert on 28/11/21.
//

import Foundation
import FirebaseAuth
import SwiftUI

extension ProfileBengkelView {
    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared

        @Published var bengkel: Bengkel?
        @Published var brands: String = ""

        var bengkelName: String {
            bengkel?.name ?? ""
        }

        var operationalHours: String {
            var opHours = ""
            if let bengkel = bengkel {
                opHours = "\(bengkel.operationalHours.open):00 - \(bengkel.operationalHours.close):00"
            }
            return opHours
        }

        var mechanicsCount: Int {
            bengkel?.mekaniks.count ?? 0
        }

        var operationalDays: String {
            var opDays = ""
            if let bengkel = bengkel {
                for (index, days) in bengkel.operationalDays.enumerated() {
                    if days == true {
                        switch index {
                        case 1:
                            opDays.append("Senin")
                        case 2:
                            opDays.append("Selasa")
                        case 3:
                            opDays.append("Rabu")
                        case 4:
                            opDays.append("Kamis")
                        case 5:
                            opDays.append("Jumat")
                        case 6:
                            opDays.append("Sabtu")
                        case 7:
                            opDays.append("Minggu")
                        default:
                            ""
                        }
                    }
                }
            }
            return opDays
        }

        init() {
            if let id = Auth.auth().currentUser?.uid {
                getBengkel(bengkelId: id)
            }
            convertBrandsToString()
        }

        func getBengkel(bengkelId: String) {
            bengkelRepository.fetch(id: bengkelId) { bengkel2 in
                self.bengkel = bengkel2
            }
        }

        func convertBrandsToString() {
            if let bengkel = bengkel {
                for motor in bengkel.brands {
                    self.brands.append(motor.rawValue)
                }
            }
        }

    }
}
