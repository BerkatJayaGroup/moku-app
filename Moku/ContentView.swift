//
//  ContentView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var repository = BengkelRepository.shared
    @ObservedObject var cRepo = CustomerRepository.shared

    var body: some View {
        MapView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
