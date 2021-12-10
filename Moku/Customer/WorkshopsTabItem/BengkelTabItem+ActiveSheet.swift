//
//  BengkelTabItem+ActiveSheet.swift
//  Moku
//
//  Created by Christianto Budisaputra on 10/12/21.
//

import Foundation

extension BengkelTabItem {
    enum ActiveSheet: String, Identifiable {
        case location
        case motor

        var id: String { self.rawValue }
    }
}
