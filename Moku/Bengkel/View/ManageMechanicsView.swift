//
//  ManageMechanicsView.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import SwiftUI
import Introspect

struct ManageMechanicsView: View {
    @State private var showModal: Bool = false
    @State var mechanics = [Mekanik]()
    @State var mechanics1 = [CalonMekanik]()
    @StateObject var viewModel: ManageMechanicsViewModel

    @State var uiTabarController: UITabBarController?

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
                            NavigationLink {
                                EditMechanic(mechanic: mechanic)
                            } label: {
                                MechanicCard(mechanic: mechanic)
                                    .padding(10)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.25)
                                    .background(AppColor.primaryBackground)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                            }
                        }
                    }
                }
                .padding(.vertical, 15)
                .navigationTitle("Mekanik")
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus")
                }).sheet(isPresented: $showModal, onDismiss: {
                    viewModel.isLoading = true
                    viewModel.fetchMechanics()
                }, content: {
                    AddMekanik(showSheetView: $showModal, mechanics: $mechanics1, isUpload: true, isManageMechanic: true)
                })
                )
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            viewModel.isLoading = true
            viewModel.fetchMechanics()
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            self.uiTabarController = UITabBarController
        }.onDisappear {
            self.uiTabarController?.tabBar.isHidden = false
        }
    }
}

struct ManageMechanicsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageMechanicsView(bengkel: .preview)
    }
}
