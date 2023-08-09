//
//  ReservationRow.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 12/8/22.
//

import SwiftUI

struct ReservationRow: View {
    let row: ReservationDetails
    var body: some View {
        HStack{
            Text(row.business_name)
                .frame(maxWidth: 75, alignment: .leading)
            Spacer()
            Text("\(dateFormat(rawDate:row.date))")
            Spacer()
            Text("\(row.hours):\(row.minute)")
            Spacer()
            Text(row.email)
        }
        .font(.system(size: 13, weight: .regular))
    }
    private func dateFormat(rawDate: Date) -> String{
        let newFormatter = ISO8601DateFormatter()
        newFormatter.formatOptions = [.withFullDate]
        let date = newFormatter.string(from: rawDate)
        return date
    }
}

struct ReservationRow_Previews: PreviewProvider {
    static var previews: some View {
        ReservationRow(row: dev.reservationDetails[0])
    }
}
