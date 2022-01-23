//
//  AppState.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @AppStorage(UserDefaults.hasOnboarded) var hasOnboarded = false
    @Published var viewID = UUID()

}
