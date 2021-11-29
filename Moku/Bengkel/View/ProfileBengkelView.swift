//
//  ProfileBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import SwiftUI

struct ProfileBengkelView: View {
    @StateObject var viewModel = ViewModel()
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        UITableView.appearance().backgroundColor = .clear
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    Image("MotorGray")
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                    Text(viewModel.bengkelName)
                    NavigationLink(destination: AllReviewView(bengkel: viewModel.bengkel ?? .preview), label: {
                        HStack {
                            Image(systemName: "star")
                            Text("\(String(format: "%.1f", viewModel.rating))")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Lihat Ulasan")
                                .fontWeight(.semibold)
                                .foregroundColor(AppColor.primaryColor)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    })
                        .frame(width: 338, height: 42)
                        .border(AppColor.primaryColor, width: 2, cornerRadius: 8)
                    NavigationLink(destination: ManageMechanicsView(bengkel: viewModel.bengkel ?? .preview), label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("\(viewModel.mechanicsCount) Mekanik")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("Atur Mechanics")
                                .fontWeight(.semibold)
                                .foregroundColor(AppColor.primaryColor)
                        }
                        .padding(.horizontal)
                        .foregroundColor(.black)
                    })
                        .frame(width: 338, height: 42)
                        .border(AppColor.primaryColor, width: 2, cornerRadius: 8)
                    VStack(alignment: .leading){
                        HStack {
                            Text("Data Bengkel")
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                            Spacer()
                            NavigationLink(destination: EditDataBengkelView(bengkel: viewModel.bengkel ?? .preview), label: {
                                Text("Sunting")
                                    .foregroundColor(AppColor.primaryColor)
                                    .fontWeight(.semibold)
                            })
                        }
                        .padding(.bottom, 16)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Brand Motor Cakupan")
                                .foregroundColor(.gray)
                            Text(viewModel.brands)
                                .foregroundColor(.black)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("CC Motor Cakupan")
                                .foregroundColor(.gray)
                            Text("110cc, 125cc, 150cc, 250cc, 500cc")
                                .foregroundColor(.black)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hari Operasional")
                                .foregroundColor(.gray)
                            Text(viewModel.operationalDays)
                                .foregroundColor(.black)
                        }
                        Divider()
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Jam Operasional")
                                .foregroundColor(.gray)
                            Text(viewModel.operationalHours)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Bengkel")
            .navigationBarColor(AppColor.primaryColor)
        }
    }
}

struct ProfileBengkelView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBengkelView()
    }
}
