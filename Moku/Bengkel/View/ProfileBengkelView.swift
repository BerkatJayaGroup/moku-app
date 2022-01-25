//
//  ProfileBengkelView.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import SwiftUI
import FirebaseAuth

struct ProfileBengkelView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    Image("MotorGray")
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                    if let bengkel = viewModel.bengkel {
                        NavigationLink(destination: BengkelProfileView(bengkel: bengkel)) {
                            Text(bengkel.name)
                        }
                    }

                    NavigationLink(destination: AllReviewView(bengkel: viewModel.bengkel ?? .preview), label: {
                        HStack {
                            Image(systemName: "star")
                            Text(viewModel.rating).fontWeight(.semibold)
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
                    VStack(alignment: .leading) {
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
                        Button("Sign out") {
                            try? Auth.auth().signOut()
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
