//
//  AllReviewView.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import SwiftUI

struct AllReviewView: View {
    @StateObject var viewModel: ViewModel
    
    init(bengkel: Bengkel){
        let viewModel 
    }
    
    var body: some View {
        ScrollView{
            ForEach(viewModel.listOfReview ?? [], id: \.user){ review in
                ReviewCard(review: Review(user: "Devin Test", rating: 5, comment: "Kerja mekanik sudah memuaskan"))
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.black, lineWidth: 0.5)
                    }
            }
        }
        .navigationTitle("Ulasan")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct AllReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AllReviewView()
    }
}
