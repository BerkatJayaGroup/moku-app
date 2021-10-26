//
//  AppState.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/10/21.
//

import SwiftUI

class AppState: ObservableObject {
    
    @AppStorage(UserDefaults.hasOnboarded) var hasOnboarded = false
    
}
