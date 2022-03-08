//
//  AssignMechanics.swift
//  Moku
//
//  Created by Mac-albert on 15/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import PartialSheet

struct AssignMechanics: View {
    @StateObject private var viewModel: AssignMechanicsViewModel
    @Binding var isActive: Bool

    init(order: Order, isRootActive: Binding<Bool>) {
        let viewModel = AssignMechanicsViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
        _isActive = isRootActive
    }

    var body: some View {
        VStack {
            Text("Tugaskan Mekanik")
                .bold()
                .padding(.top, 36)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 24) {
                    if let bengkel = viewModel.bengkel {
                        ForEach(0..<bengkel.mekaniks.count, id: \.self) { mech in
                            if viewModel.unavailableMechs.contains(bengkel.mekaniks[mech].name) {
                                EmptyView()
                            } else {
                                componentMechanics(mech: mech)
                            }
                        }
                    }
                }.padding(.horizontal, 8)
            }.frame(height: 160)

            Spacer()

            Button {
                self.isActive = false
                viewModel.addMekanik()
                viewModel.updateStatusOrder(status: .scheduled)
                UIApplication.shared.keyWindowPresentedController?.dismiss(animated: true)
            } label: {
                HStack {
                    Spacer()
                    Text("Selesai")
                    Spacer()
                }
                .padding(12)
                .foregroundColor(Color(uiColor: .systemBackground))
                .background(AppColor.primaryColor)
                .cornerRadius(8)
                .padding(.horizontal, 36)
            }
        }
        .padding()
        .frame(height: 220)
        .onAppear {
            viewModel.viewOnAppear()
        }
    }

    private func componentMechanics(mech: Int) -> some View {
        VStack {
            if let mechPhoto: String = viewModel.bengkel?.mekaniks[mech].photo,
               let photoUrl: URL = URL(string: mechPhoto), photoUrl.isValidURL {
                WebImage(url: URL(string: mechPhoto))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppColor.primaryColor, lineWidth: viewModel.selectedMechanics == mech ? 3 : 0))
                    .onTapGesture {
                        viewModel.selectedMechanics = mech
                    }
            } else {
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppColor.primaryColor, lineWidth: viewModel.selectedMechanics == mech ? 3 : 0))
                    .onTapGesture {
                        viewModel.selectedMechanics = mech
                    }
            }
            Text(viewModel.bengkel?.mekaniks[mech].name ?? "Tono")
                .font(.system(size: 14))
        }
    }
}
