//
//  ModalSelectBrand.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI

struct ModalSelectBrand: View {
    @Binding var isPresented: Bool
    @Binding var message: String
    var selectedList: [Bool]?
    var body: some View {
        List {
            Text("Halo")
        }
    }
}

struct ModalSelectBrand_Previews: PreviewProvider {
    static var previews: some View {
        ModalSelectBrand(isPresented: .constant(false), message: .constant(""))
    }
}
