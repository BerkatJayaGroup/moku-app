//
//  BengkelView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI
import Foundation
import Combine
import SDWebImageSwiftUI
import FirebaseAuth

class BengkelTabItemViewModel: ObservableObject {
    @ObservedObject private var session = SessionService.shared

    @Published var bengkel: Bengkel?

    private var subscriptions = Set<AnyCancellable>()

    init() {
        setup()
    }

    private func setup() {
        session.$user.sink { user in
            guard case .bengkel(let bengkel) = user else { return }
            self.bengkel = bengkel
        }.store(in: &subscriptions)
    }
}

struct BengkelTabItemView: View {

    @StateObject private var viewModel = BengkelTabItemViewModel()

    var body: some View {
        if let bengkel = viewModel.bengkel {
            VStack {
                if let bengkelPhoto = bengkel.photos.first, let photoUrl = URL(string: bengkelPhoto) {
                    WebImage(url: photoUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                }
                Text(bengkel.name)
                Spacer()
            }
        } else {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}

struct BengkelView: View {

    @State var bengkel: Bengkel?

    var body: some View {
        contentView()
            .onAppear {
                if case .bengkel(let bengkel) = SessionService.shared.user {
                    self.bengkel = bengkel
                }
            }
    }

    @ViewBuilder
    private func contentView() -> some View {
        if bengkel != nil {
            TabView {
                BookingTabItemView()
                    .tabItem {
                        Image(systemName: "wrench.and.screwdriver.fill")
                        Text("Booking")
                    }
                PesananTabBengkelView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Pesanan")
                    }
                ProfileBengkelView()
                    .tabItem {
                        Image(systemName: "GarasiTabItemIcon")
                        Text("Bengkel")
                    }
            }
        } else {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}
