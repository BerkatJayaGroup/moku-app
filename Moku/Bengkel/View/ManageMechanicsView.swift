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
    @StateObject var viewModel: ManageMechanicsViewModel

    init(bengkel: Bengkel) {
        let viewModel = ManageMechanicsViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            ForEach(viewModel.mechanics ?? [], id: \.id) { mechanic in
                NavigationLink(destination: EditMechanic(mechanic: mechanic)) {
                    MechanicCard(mechanic: mechanic)
                        .foregroundColor(AppColor.primaryColor)
                }
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
            AddMekanik(showSheetView: $showModal, mechanics: $mechanics1, isUpload: true, isManageMechanic: true)
        })
        )
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMechanics()
        }
    }
}

struct ManageMechanicsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageMechanicsView(bengkel: .preview)
    }
}
