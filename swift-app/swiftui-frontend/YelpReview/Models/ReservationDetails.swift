//
//  ReservationDetails.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 12/1/22.
//

import Foundation

struct ReservationDetails: Codable, Hashable{
    let business_id: String
    let business_name: String
    let email: String
    let date: Date
    let hours: String
    let minute: String
    static let empty = ReservationDetails(business_id: "", business_name: "", email: "", date: Date.now, hours: "10", minute: "00")
}
