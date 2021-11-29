//
//  AllReviewViewModel.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import SwiftUI
import Foundation
import FirebaseAuth
import Combine

extension AllReviewView {
    enum SortType: String, CaseIterable, Identifiable {
        case latest = "Terbaru"
        case lowestRating = "Rating Terendah"
        case highestRating = "Rating Tertinggi"

        var id: String { self.rawValue }
    }

    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared

        private var listOfReview = [Review]()
        @Published var sortedListOfReview = [Review]()
        @Published var bengkel: Bengkel

        @Published var isPresentingSortingSheet = false
        @Published var sortType: SortType = .latest
        @Published var selectedSortType: SortType?

        private var subscriptions = Set<AnyCancellable>()

        init(bengkel: Bengkel) {
            self.bengkel = bengkel

            $bengkel.sink { [self] updatedBengkel in
                listOfReview = updatedBengkel.reviews
                let sortedReviews = listOfReview.sorted {
                    sortReviews(sortType: sortType, $0, $1)
                }
                sortedListOfReview = sortedReviews
            }.store(in: &subscriptions)

            $sortType.sink { [self] sortType in
                let sortedReviews = listOfReview.sorted {
                    sortReviews(sortType: sortType, $0, $1)
                }
                sortedListOfReview = sortedReviews
            }.store(in: &subscriptions)
        }

        private func sortReviews(sortType: SortType, _ first: Review, _ second: Review) -> Bool {
            switch sortType {
            case .latest: return first.timestamp < second.timestamp
            case .lowestRating: return first.rating < second.rating
            case .highestRating: return first.rating > second.rating
            }
        }
    }
}
