//
//  UlasanModal.swift
//  Moku
//
//  Created by Mac-albert on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UlasanModal: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ViewModel
    @State private var test: Bool = false
    init(bengkel: Bengkel, selected: Int, order: Order) {
        _viewModel = StateObject(wrappedValue: ViewModel(bengkel: bengkel, selected: selected, order: order))
    }
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text(viewModel.bengkel.name)
                        .font(.system(size: 20, weight: .semibold))
                    Text(viewModel.bengkel.address)
                        .font(.system(size: 13))
                }
                .padding()
                if let photo = viewModel.bengkel.photos.first {
                    WebImage(url: URL(string: photo))
                        .resizable()
                        .frame(width: 220, height: 220)
                        .padding(.bottom, 40)
                }
                Divider()
                    .padding(.horizontal)
                Text("Bagaimana Pengalamanmu?")
                    .font(.system(size: 17, weight: .semibold))
                HStack(spacing: 10) {
                    ForEach(0..<5) { item in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(viewModel.selected >= item ? .yellow : .gray)
                            .onTapGesture {
                                viewModel.selected = item
                            }
                    }
                }
                HStack {
                    Text("Beri Komentar Tambahan")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                }
                .padding(.horizontal, 30)
                CustomTextField(placeholder: "Berikan komentar anda terhadap kinerja Mekanik", text: $viewModel.text)
                    .frame(width: 325, height: 75)
                    .font(.body)
                    .background(Color(UIColor.systemGray6))
                    .accentColor(.green)
                    .cornerRadius(8)
                    .padding(.horizontal)
                HStack {
                    Image(systemName: viewModel.isCheck ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            if viewModel.isCheck {
                                viewModel.isCheck = false
                            } else {
                                viewModel.isCheck = true
                            }
                        }
                        .font(.system(size: 24))
                        .foregroundColor(AppColor.primaryColor)
                    Text("Tambahkan sebagai bengkel favorit")
                }
                .padding()
                Button {
                    viewModel.sendReview()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Kirim")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(width: 325, height: 45)
                        .background(Color("PrimaryColor"))
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Ulasan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Batal") {
               presentationMode.wrappedValue.dismiss()
            })
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }

}
