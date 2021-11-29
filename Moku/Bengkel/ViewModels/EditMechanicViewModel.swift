//
//  EditMechanicViewModel.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth

extension EditMechanic{
    class ViewModel: ObservableObject{
        @ObservedObject var bengkelRepository: BengkelRepository = .shared
        
        @Published var mechanic: Mekanik
        @Published var image: [UIImage] = []
        @Published var showImagePicker: Bool = false
        @Published var showActionSheet = false
        @Published var mechanicName: String
        @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        init(mechanic: Mekanik){
            self.mechanic = mechanic
            self.mechanicName = mechanic.name
        }
        
        func removeMechanic(){
            guard let id = Auth.auth().currentUser?.uid else { return }
            bengkelRepository.removeMechanic(mechanic: mechanic, to: id)
        }
        
        func updateMechanic(){
            guard let image = image.first, let id = Auth.auth().currentUser?.uid else { return }
            
            if self.image.isEmpty{
                let newMechanic = Mekanik(name: mechanicName, photo: self.mechanic.photo)
                removeMechanic()
                bengkelRepository.appendMechanic(mechanic: newMechanic, to: id)
            }
            else {
                removeMechanic()
                StorageService.shared.upload(image: image,
                                             path: "\(id)/mechanics/\(UUID().uuidString)") { url, _ in
                    guard let url = url?.absoluteString else { return }
                    let newMechanic = Mekanik(name: self.mechanicName, photo: url)
                    self.bengkelRepository.appendMechanic(mechanic: newMechanic,
                                                          to: id)
                }
            }
        }
    }
}
