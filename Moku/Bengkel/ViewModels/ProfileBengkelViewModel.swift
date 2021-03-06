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

        var rating: String {
            bengkel?.averageRating ?? ""
        }

        var brands: String {
            var brand: String = ""
            if let bengkel = bengkel {
                for motor in bengkel.brands {
                    brand.append("\(motor.rawValue), ")
                }
            }
            return brand
        }

        var operationalDays: String {
            var opDays = [String]()
            if let bengkel = bengkel {
                for (index, daySelected) in bengkel.operationalDays.enumerated() where daySelected {
                    switch index {
                    case 0: opDays.append("Senin")
                    case 1: opDays.append("Selasa")
                    case 2: opDays.append("Rabu")
                    case 3: opDays.append("Kamis")
                    case 4: opDays.append("Jumat")
                    case 5: opDays.append("Sabtu")
                    case 6: opDays.append("Minggu")
                    default: continue
                    }
                }
            }
            return opDays.joined(separator: ", ")
        }

        init() {
            if let id = Auth.auth().currentUser?.uid {
                getBengkel(bengkelId: id)
            }
        }

        func getBengkel(bengkelId: String) {
            bengkelRepository.fetch(id: bengkelId) { bengkel2 in
                self.bengkel = bengkel2
            }
        }
    }
}
