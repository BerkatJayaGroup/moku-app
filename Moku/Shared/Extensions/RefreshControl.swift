//
//  RefreshControl.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 09/02/22.
//

import SwiftUI

struct RefreshControl: View {
    var coordinateSpace: CoordinateSpace
    @Binding var isFinishEditData: Bool
    var onRefresh: () -> Void
    @State var refresh: Bool = false
    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: coordinateSpace).midY > 50 || isFinishEditData {
                Spacer()
                    .onAppear {
                        if refresh == false {
                            // call refresh once if pulled more than 50px
                            onRefresh()
                        }
                        isFinishEditData = false
                        refresh = true
                    }
            } else if geo.frame(in: coordinateSpace).maxY < 1 {
                Spacer()
                    .onAppear {
                        // reset  refresh if view shrink back
                        refresh = false
                    }
            }
            ZStack(alignment: .center) {
                // show loading if refresh called
                if refresh {
                    ProgressView()
                }
                // mimic static progress bar with filled bar to the drag percentage
                else {
                    ForEach(0..<8) { tick in
                          VStack {
                              Rectangle()
                                .fill(Color(UIColor.tertiaryLabel))
                                .opacity((Int((geo.frame(in: coordinateSpace).midY)/7) < tick) ? 0 : 1)
                                  .frame(width: 3, height: 7)
                                .cornerRadius(3)
                              Spacer()
                      }.rotationEffect(Angle.degrees(Double(tick)/(8) * 360))
                   }.frame(width: 20, height: 20, alignment: .center)
                }
            }.frame(width: geo.size.width)
        }.padding(.top, -50)
    }
}
