//
//  BengkelView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI

struct BengkelView: View {
    @State var bengkel: Bengkel

    init(for bengkel: Bengkel) {
        _bengkel = State(wrappedValue: bengkel)
    }

    var body: some View {
        Text("Bengkel View")
    }
}
