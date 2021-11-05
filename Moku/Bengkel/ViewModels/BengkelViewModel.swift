//
//  BengkelViewModel.swift
//  Moku
//
//  Created by Devin Winardi on 01/11/21.
//

import Foundation

final class BengkelViewModel: ObservableObject {
    private let repository: BengkelRepository = .shared

    static let shared = BengkelViewModel()

    private init() {}

    func create (_ bengkel: Bengkel) {
        repository.add(bengkel: bengkel)
    }
}
