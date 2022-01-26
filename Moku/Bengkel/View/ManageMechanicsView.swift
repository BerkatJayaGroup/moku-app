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
        VStack {
            if viewModel.isLoading == true {
                ProgressView()
            } else {
                ScrollView {
                    if let mechanicsList = viewModel.mechanics {
                        ForEach(mechanicsList, id: \.id) { mechanic in
                            NavigationLink(destination: EditMechanic(mechanic: mechanic)) {
                                MechanicCard(mechanic: mechanic)
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Mekanik")
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus")
                }).sheet(isPresented: $showModal, onDismiss: {
                    viewModel.isLoading = true
                    viewModel.fetchMechanics()
                }, content: {
                    AddMekanik(showSheetView: $showModal, mechanics: $mechanics1, isUpload: true)
                })
                )
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            viewModel.isLoading = true
            viewModel.fetchMechanics()
        }
    }
}

struct ManageMechanicsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageMechanicsView(bengkel: .preview)
    }
}
