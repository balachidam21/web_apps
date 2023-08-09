//
//  IPInfo.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/25/22.
//

import Foundation

struct IPInfo: Codable {
    let ip, hostname, city, region: String?
    let country, loc, org, postal: String?
    let timezone: String?
    var location: Location{
        get{
            var coord = Location(lat: nil, lng: nil)
            if let temp = loc?.components(separatedBy: ",") {
                coord = Location(lat: Double(temp[0]), lng: Double(temp[1]))
                
            }
            return coord
        }
    }
}
