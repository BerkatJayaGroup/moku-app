//
//  UlasanModal.swift
//  Moku
//
//  Created by Mac-albert on 10/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UlasanModal: View {
    @State var selected: Int
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var bengkel: Bengkel
    @State private var text = ""
    @State private var isCheck: Bool = false
    var bengkelRepository: BengkelRepository = .shared
    var customerRepository: CustomerRepository = .shared

    var body: some View {
        VStack {
            Text(bengkel.name)
                .font(.system(size: 20, weight: .semibold))
            Text(bengkel.address)
                .font(.system(size: 13))
            if let photo = bengkel.photos.first {
                WebImage(url: URL(string: photo))
                    .resizable()
                    .frame(width: 220, height: 220)
            }
            Divider()
            Text("Bagaimana Pengalamanmu?")
                .font(.system(size: 17, weight: .semibold))
            HStack(spacing: 10) {
                ForEach(0..<5) { item in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(self.selected >= item ? .yellow : .gray)
                        .onTapGesture {
                            selected = item
                        }
                }
            }
            HStack {
                Text("Beri Komentar Tambahan")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.horizontal, 30)
            CustomTextField(placeholder: "Berikan komentar anda terhadap kinerja Mekanik", text: $text)
                .frame(width: 325, height: 75)
                .font(.body)
                .background(Color(UIColor.systemGray6))
                .accentColor(.green)
                .cornerRadius(8)
                .padding(.horizontal)
            HStack {
                Image(systemName: isCheck ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        if isCheck {
                            isCheck = false
                        } else {
                            isCheck = true
                        }
                    }
                Text("Tambahkan sebagai bengkel favorit")
            }
            .padding()

            Button(action: {
                bengkelRepository.addRating(bengkelId: bengkel.id, review: Review(user: "Buwono",
                                                                                  rating: selected,
                                                                                  comment: text,
                                                                                  timestamp: Date()))
                print("udah kekirim")
            }) {
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
    }
}

struct UlasanModal_Previews: PreviewProvider {
    static var previews: some View {
        UlasanModal(selected: 4, bengkel: .preview)
    }
}
