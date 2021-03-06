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
    @State var isActive: Bool = false
    var isFrom: Bool
    init(order: Order, isFrom: Bool) {
        _order = State(wrappedValue: order)
        self.isFrom = isFrom
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
                if isFrom == true {
                    Button {
                        print("Button Tap")
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.top, -10)
                    .offset(x: 0, y: 10)
                }
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
                                        self.isActive = true
                                    }
                                    .sheet(isPresented: self.$isActive) {
                                        UlasanModal(bengkel: bengkel, selected: selected, order: order)
                                    }
                            }
                            Spacer()
                        }
                    }
                }
            }
        } else {
            ActivityIndicator(.constant(true))
        }
    }
}
