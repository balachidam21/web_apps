//
//  ReservationViewModel.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 12/6/22.
//

import Foundation

class ReservationViewModel: ObservableObject{
    @Published var isThereReservations: Bool = false
    @Published var reservationDetails: [ReservationDetails] = []
    init()
    {
        self.reservationDetails =  ReservationStorage.getReservations()
        if self.reservationDetails.count > 0 {
            self.isThereReservations = true
        }
    }
    func deleteItems(offsets: IndexSet){
        self.reservationDetails.remove(atOffsets: offsets)
        ReservationStorage.storeReservations(reservationDetails: self.reservationDetails)
        if self.reservationDetails.count == 0 {
            self.isThereReservations = false
        }
    }
}
