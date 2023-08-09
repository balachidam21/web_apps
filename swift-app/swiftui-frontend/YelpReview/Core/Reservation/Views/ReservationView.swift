//
//  ReservationView.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import SwiftUI

struct ReservationView: View {
    @StateObject var viewModel =  ReservationViewModel()
    var body: some View {
        VStack{
            if !viewModel.isThereReservations {
                emptyReservation
            }else {
                Form {
                    ForEach(viewModel.reservationDetails, id:\.self) {
                        reservation in
                        ReservationRow(row: reservation)
                            .padding(0)
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
                
            }
        }.navigationTitle("Your Reservations")
    }
}

extension ReservationView {
    private var emptyReservation: some View {
        Text("No bookings found")
            .foregroundColor(Color.red)
            .opacity(0.5)
        
    }
    
}

struct ReservationView_Previews: PreviewProvider {
    @AppStorage("myReservation") var app: Data?
    
    static var previews: some View {
        ReservationView()
    }
}
