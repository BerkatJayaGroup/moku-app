//
//  ModalSearchMotor.swift
//  Moku
//
//  Created by Devin Winardi on 27/10/21.
//

import SwiftUI

struct ModalSearchMotor: View {
    @Binding var showModal: Bool
    @State private var searchText = ""

    var motors = [TestMotor(name: "Honda Beat"), TestMotor(name: "Honda Vario")]

    var body: some View {
        NavigationView {
            VStack {
                SearchBarMotor(text: $searchText)
                List(motors.filter({
                    searchText.isEmpty ? true : $0.name.contains(searchText)
                })) { item in
                    Text(item.name)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationBarItems(leading: Button("Kembali",
                                                 action: {showModal = false}))
        }
    }
}

struct ModalSearchMotor_Previews: PreviewProvider {
    static var previews: some View {
        ModalSearchMotor(showModal: .constant(true))
    }
}

struct TestMotor: Identifiable {
    var id = UUID()

    var name: String
}
