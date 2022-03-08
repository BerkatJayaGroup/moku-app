//
//  URLExtension.swift
//  Moku
//
//  Created by Christianto Budisaputra on 22/02/22.
//

import UIKit

extension URL {
    var isValidURL: Bool {
        UIApplication.shared.canOpenURL(self)
    }
}
