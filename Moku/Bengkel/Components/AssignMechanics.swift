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

    init(order: Order, showMechs: Bool, title: String) {
        let viewModel = ViewModel(order: order, showMechs: showMechs, title: title)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack{
            Text("Tugaskan Mekanik")
                .font(.system(size: 18))
                .fontWeight(.bold)
            ScrollView(.horizontal) {
                LazyHStack {
                    if let bengkel = viewModel.bengkel {
                        ForEach(0..<bengkel.mekaniks.count, id: \.self) { mech in
                            VStack {
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
                }
                .padding(.horizontal, 8)
            }
            Spacer()
            Button(action:{
                OrderRepository.shared.addMekanik(orderId: viewModel.order.id, mechanicsName: viewModel.bengkel?.mekaniks[viewModel.selectedMechanics].name ?? "")
            }, label: {
                Text("Selesai")
                    .frame(width: 310, height: 45, alignment: .center)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .background(AppColor.primaryColor)
            })
        }
        .padding()
        .frame(height: 240)

    }
}

 struct AssignMechanics_Previews: PreviewProvider {
    static var previews: some View {
        AssignMechanics(order: .preview, showMechs: true, title: "Tugaskan Mekanik")
            .previewLayout(.sizeThatFits)
    }
 }
