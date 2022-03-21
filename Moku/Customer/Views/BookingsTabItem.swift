//
//  BookingsTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import SwiftUI

struct BookingsTabItem: View {
    @StateObject private var viewModel = BookingsTabItemViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(.accentColor)
                .ignoresSafeArea()
                .frame(height: 0)

            VStack {
                Picker("Bookings", selection: $viewModel.segmentSelection) {
                    ForEach(viewModel.segments) { segment in
                        Text(segment.rawValue).tag(segment)
                    }
                }.pickerStyle(SegmentedPickerStyle())

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.segmentedOrders, id: \.id) { order in
                            NavigationLink(destination: BookingDetail(order: order)) {
                                let viewModel = BookingComponentListViewModel(order: order)
                                BookingComponentList(viewModel: viewModel).padding(4)
                            }
                        }
                    }.padding(.vertical)
                }
                .overlay {
                    BookingEmptyComponent(state: viewModel.segmentSelection == .inProgress)
                        .hidden(!viewModel.segmentedOrders.isEmpty)
                }
            }.padding()
        }.onAppear {
            viewModel.viewOnAppear()
        }
    }
}

struct BookingsTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BookingsTabItem()
    }
}
