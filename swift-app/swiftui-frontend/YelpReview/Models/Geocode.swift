//
//  Geocode.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/25/22.
//

import Foundation

struct Geocode: Codable {
    let results: [Result]?
    let status: String?
}


struct Result: Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress: String?
    let geometry: Geometry?
    let placeID: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case types
    }
}


struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}


struct Geometry: Codable {
    let bounds: Bounds?
    let location: Location?
    let locationType: String?
    let viewport: Bounds?

    enum CodingKeys: String, CodingKey {
        case bounds, location
        case locationType = "location_type"
        case viewport
    }
}


struct Bounds: Codable {
    let northeast, southwest: Location?
}


struct Location: Codable {
    let lat, lng: Double?
}
