//
//  AppStorage.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 12/8/22.
//

import Foundation
import SwiftUI
class ReservationStorage  {
    @AppStorage("myReservation") static var app: Data?
    static func getReservations() -> [ReservationDetails]{
        var reservationDetails: [ReservationDetails] = []
        if let reservations = try? JSONDecoder().decode([ReservationDetails].self, from: self.app ?? Data()) {
            reservationDetails = reservations
        }
        return reservationDetails
    }
    
    static func storeReservations(reservationDetails: [ReservationDetails]){
        if let reservations = try? JSONEncoder().encode(reservationDetails) {
            self.app = reservations
        }
    }

}
