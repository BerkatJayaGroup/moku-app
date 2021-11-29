//
//  AllReviewViewModel.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import SwiftUI
import Foundation
import FirebaseAuth

extension AllReviewView {
    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared

        @Published var listOfReview: [Review]?
        @Published var bengkel: Bengkel

        init(bengkel: Bengkel) {
            self.bengkel = bengkel
            self.listOfReview = bengkel.reviews
        }

//        func getListOfReview(){
//            if let id = Auth.auth().currentUser?.uid{
//                bengkelRepository.fetch(id: id) { bengkel in
//                    self.bengkel = bengkel
//                }
//            }
//        }
    }
}
