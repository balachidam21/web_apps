//
//  BusinessSearch.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation
import CoreLocation
/*
 {
     "businesses": [
         {
             "id": "AUbKbVQAUNI6Vr6LYtOZzA",
             "alias": "california-donuts-los-angeles-2",
             "name": "California Donuts",
             "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/f4qoSJYs1SFdOU2pYaGMWQ/o.jpg",
             "is_closed": false,
             "url": "https://www.yelp.com/biz/california-donuts-los-angeles-2?adjust_creative=53JdP5ZjnkJIAgHQCqUXNw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=53JdP5ZjnkJIAgHQCqUXNw",
             "review_count": 3001,
             "categories": [
                 {
                     "alias": "bakeries",
                     "title": "Bakeries"
                 },
                 {
                     "alias": "donuts",
                     "title": "Donuts"
                 },
                 {
                     "alias": "coffee",
                     "title": "Coffee & Tea"
                 }
             ],
             "rating": 4,
             "coordinates": {
                 "latitude": 34.068796,
                 "longitude": -118.293089
             },
             "transactions": [
                 "delivery",
                 "pickup"
             ],
             "price": "$$",
             "location": {
                 "address1": "3540 W 3rd St",
                 "address2": "",
                 "address3": "",
                 "city": "Los Angeles",
                 "zip_code": "90020",
                 "country": "US",
                 "state": "CA",
                 "display_address": [
                     "3540 W 3rd St",
                     "Los Angeles, CA 90020"
                 ]
             },
             "phone": "+12133853318",
             "display_phone": "(213) 385-3318",
             "distance": 5212.519167985251
         },

     ],
     "total": 10
 }
 */

struct BusinessSearch: Codable {
    let businesses: [BusinessSearchRow]
    let total: Int
    
    static let empty = BusinessSearch(businesses: [], total: 0)
}

struct BusinessSearchRow: Codable, Identifiable {
    let id, alias, name: String
    let imageURL: String
    let isClosed: Bool?
    let url: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Coordinates?
    let transactions: [Transaction]?
    let price: String?
    let location: LocationSearch?
    let phone, displayPhone: String?
    let distance: Double?
    var distanceInMiles: Int {
        get {
            let x = (distance ?? 1.0) / 1609.34
            if Int(x) == 0 {
                return 1
            }
            return Int(x)
        }
    }
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}


struct Category: Codable, Hashable {
    let alias, title: String?
}

struct Coordinates: Codable {
    let latitude, longitude: Double
    var mapCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct LocationSearch: Codable {
    let address1: String?
    let address2, address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

enum Transaction: String, Codable {
    case delivery = "delivery"
    case pickup = "pickup"
}
