//
//  AssignMechanics.swift
//  Moku
//
//  Created by Mac-albert on 15/11/21.
//

import SwiftUI
import HalfASheet
import SDWebImageSwiftUI
import PartialSheet

struct AssignMechanics: View {
    @StateObject private var viewModel: ViewModel
    @Binding var isActive: Bool
    init(order: Order, isRootActive: Binding<Bool>) {
        let viewModel = ViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
        _isActive = isRootActive
    }
    
    var body: some View {
        VStack{
            Text("Tugaskan Mekanik")
                .font(.system(size: 18))
                .fontWeight(.bold)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 24) {
                    if let bengkel = viewModel.bengkel {
                        ForEach(0..<bengkel.mekaniks.count, id: \.self) { mech in
                            if viewModel.availableMechs.contains(bengkel.mekaniks[mech].name){
                                EmptyView()
                            } else{
                                componentMechanics(mech: mech)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            Spacer()
            Button(action:{
                self.isActive = false
                viewModel.addMekanik()
                viewModel.updateStatusOrder()
            }, label: {
                Text("Selesai")
                    .frame(width: 310, height: 45, alignment: .center)
                    .background(AppColor.primaryColor)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            })
        }
        .padding()
        .frame(height: 240)
        
    }
    
    private func componentMechanics(mech: Int) -> some View{
        VStack{
            if let mechPhoto = viewModel.bengkel?.mekaniks[mech].photo {
                if viewModel.selectedMechanics == mech{
                    WebImage(url: URL(string: "https://avatars.githubusercontent.com/u/53547157?v=4"))
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppColor.primaryColor, lineWidth: 5))
                        .onTapGesture{
                            viewModel.selectedMechanics = mech
                        }
                }
                else{
                    WebImage(url: URL(string: "https://avatars.githubusercontent.com/u/53547157?v=4"))
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .onTapGesture{
                            viewModel.selectedMechanics = mech
                        }
                }
            }
            Text(viewModel.bengkel?.mekaniks[mech].name ?? "Tono")
                .font(.system(size: 14))
        }
    }
    
}
