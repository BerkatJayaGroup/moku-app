//
//  ManageMechanicsView.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import SwiftUI

struct ManageMechanicsView: View {
    @State private var showModal: Bool = false
    @State var mechanics = [Mekanik]()
    @State var mechanics1 = [CalonMekanik]()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(mechanics, id: \.id){ mechanic in
                    MechanicCard(mechanic: mechanic)
                }
            }
            .padding()
            .navigationTitle("Mekanik")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showModal = true
            }, label: {
                Image(systemName: "plus")
                
            }).sheet(isPresented: $showModal, content: {
                AddMekanik(showSheetView: $showModal, mechanics: $mechanics1)
            })
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ManageMechanicsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageMechanicsView()
    }
}
