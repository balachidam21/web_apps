//
//  BusinessTableRow.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import SwiftUI
import Kingfisher

struct BusinessTableRow: View {
    let rowID: Int
    let row: BusinessSearchRow
    var body: some View {
        NavigationLink(destination: Detail(business: row), label: {
            HStack(spacing: 0){
                Text("\(rowID)")
                    .foregroundColor(.black)
                    .frame(minWidth: 30, alignment: .center)
                Spacer()
                KFImage(URL(string: row.imageURL)!)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                Spacer()
                HStack{
                    Text("\(row.name)")
                        .foregroundColor(.gray)
                        .frame(maxWidth: 100)
                }
                Spacer()
                Text(row.rating?.asDecimalWith2Decimals() ?? "0.00")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
                Text("\(row.distanceInMiles)")
                    .foregroundColor(.black)
                    .bold()
                    .frame(alignment: .trailing)
            }
            
        })
    }
}

struct BusinessTableRow_Previews: PreviewProvider {
    static var previews: some View {
        BusinessTableRow(rowID: 1, row: dev.business.businesses[0])
    }
}
