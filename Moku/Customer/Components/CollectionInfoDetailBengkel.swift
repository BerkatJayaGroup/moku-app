//
//  CollectionInfoDetailBengkel.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet

struct CollectionInfoDetailBengkel: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var titleInfo: String
    var imageInfo: String
    var mainInfo: String
    var cta: String
    var body: some View {
        VStack(spacing: 6) {
            Text("\(titleInfo)")
                .font(Font.system(size: 11))
                .foregroundColor(.gray)
            HStack {
                Image(systemName: "\(imageInfo)")
                    .foregroundColor(Color("PrimaryColor"))
                Text("\(mainInfo)")
                    .fontWeight(.bold)
            }
            if cta == "Lihat Detail"{
                Button(action: {
                    self.partialSheetManager.showPartialSheet({
                        print("normal sheet dismissed")
                    }) {
                        SheetView()
                    }
                }) {
                    Text("\(cta)")
                        .foregroundColor(Color("PrimaryColor"))
                }
            } else {
                Text("\(cta)")
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
    }
}

struct CollectionInfoDetailBengkel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CollectionInfoDetailBengkel(titleInfo: "Rating", imageInfo: "star", mainInfo: "5.0", cta: "Lihat Detail")
                .previewLayout(.sizeThatFits)
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

extension CollectionInfoDetailBengkel {
    struct SheetView: View {
        var body: some View {
            VStack {
                Group {
                    HStack {
                        Text("Jam Buka")
                            .font(.headline)
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        VStack(spacing: 8){
                            DayByDay(day: "Senin", time: "10.00-17.00")
                            DayByDay(day: "Selasa", time: "10.00-17.00")
                            DayByDay(day: "Rabu", time: "10.00-17.00")
                            DayByDay(day: "Kamis", time: "10.00-17.00")
                            DayByDay(day: "Jumat", time: "10.00-17.00")
                        }
                        VStack(spacing: 8){
                            DayByDay(day: "Sabtu", time: "10.00-17.00")
                            DayByDay(day: "Minggu", time: "10.00-17.00")
                            Spacer()
                        }
                    }
                }
            }
            .padding()
            .frame(height: 320)
        }
    }
}
