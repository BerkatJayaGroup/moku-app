//
//  ViewExtension.swift
//  Moku
//
//  Created by Mac-albert on 11/11/21.
//

import Foundation
import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
