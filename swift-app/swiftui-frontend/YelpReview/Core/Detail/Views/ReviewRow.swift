//
//  ReviewRow.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/27/22.
//

import SwiftUI

struct ReviewRow: View {
    let row: Review
    var body: some View {
        
        VStack(spacing:10){
            HStack{
                if let name = row.userName{
                    Text(name)
                        .fontWeight(.bold)
                }
                Spacer()
                if let rating = row.rating{
                    Text("\(rating)/5")
                        .fontWeight(.bold)
                }
            }
            HStack{
                if let text = row.text {
                    Text(text)
                        .foregroundColor(.gray)
                }
            }
            HStack{
                Spacer()
                if let time = row.timeCreated{
                    Text(time)
                        .font(.subheadline)
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct ReviewRow_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(row: dev.review)
    }
}
