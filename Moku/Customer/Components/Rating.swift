//
//  Rating.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct Rating: View {
    @State var selected = -1
    @State var order: Order
    @ObservedObject var bengkelRepository: BengkelRepository = .shared
    @State var bengkel: Bengkel?
    @State private var sheetViewModal = false
    init(order: Order) {
        _order = State(wrappedValue: order)
    }
    var body: some View {
        content.onAppear {
            BengkelRepository.shared.fetch(id: order.bengkelId) { bengkel in
                self.bengkel = bengkel
            }
        }
    }
    @ViewBuilder

    var content: some View {
        if let bengkel = bengkel {
            VStack(alignment: .trailing) {
                Button {
                    print("Button Tap")

                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("PrimaryColor"))
                }
                .padding(.top, -10)
                .offset(x: 0, y: 10)

                HStack {
                    if let photo = bengkel.photos.first {
                        WebImage(url: URL(string: photo))
                            .resizable()
                            .frame(width: 85, height: 85, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)

                    } else {
                        Image(systemName: "lasso.and.sparkles")
                            .resizable()
                            .frame(width: 85, height: 85, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading) {
                        Text(bengkel.name)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .padding(.bottom, 0.5)

                        Text("\(order.typeOfService.rawValue), \(order.schedule)")
                            .font(.system(size: 11))
                            .foregroundColor(Color.gray)

                        HStack(spacing: 10) {
                            ForEach(0..<5) { item in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(self.selected >= item ? .yellow : .gray)
                                    .onTapGesture {
                                        self.selected = item
                                        sheetViewModal = true
                                    }
                                    .sheet(isPresented: $sheetViewModal) {
                                        UlasanModal(bengkel: bengkel, selected: selected)
                                    }
                            }
                            Spacer()
                        }
                    }
                }
            }
        } else {
            //            TODO: Loading Screen
            Text("Tambahin Loading Screen dong pas Production")
        }
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating(order: Order(id: "1GYgKE6tXGRS3icCtVxI",
                            bengkelId: "pX578lcGxL1I1b2j9a1y",
                            customerId: "mRJRlGEwQ7sSOsY2xjSf",
                            motor: Motor(brand: .honda,
                                         model: "Beat",
                                         cc: 110),
                            typeOfService: .perbaikan,
                            schedule: Date()))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension Rating {
    class RatingViewModel: ObservableObject {
        func convertBengkelId(_ bengkel: Bengkel) {

        }
    }
}
