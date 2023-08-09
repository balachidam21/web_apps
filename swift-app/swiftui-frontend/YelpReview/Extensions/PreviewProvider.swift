//
//  PreviewProvider.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation
import SwiftUI

extension PreviewProvider{
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}
let inputRow = BusinessSearchRow(
    id: "AUbKbVQAUNI6Vr6LYtOZzA",
    alias: "california-donuts-los-angeles-2",
    name: "SK Donuts & Croissant",
    imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/f4qoSJYs1SFdOU2pYaGMWQ/o.jpg",
    isClosed: false,
    url:"https://www.yelp.com/biz/california-donuts-los-angeles-2?adjust_creative=53JdP5ZjnkJIAgHQCqUXNw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=53JdP5ZjnkJIAgHQCqUXNw",
    reviewCount: 3001,
    categories: [Category(alias: "bakeries", title: "Bakeries"),Category(alias: "donuts", title: "Donuts"), Category(alias: "coffee", title: "Coffee & Tea")],
    rating: 4,
    coordinates: Coordinates(latitude: 34.068796, longitude: -118.293089),
    transactions: [Transaction.delivery,Transaction.pickup],
    price: "$$",
    location: LocationSearch(
        address1: "3540 W 3rd St",
        address2: "",
        address3: "",
        city: "Los Angeles",
        zipCode: "90020",
        country: "US",
        state: "CA",
        displayAddress: ["3540 W 3rd St","Los Angeles, CA 90020"]),
    phone: "+12133853318",
    displayPhone: "(213) 385-3318",
    distance: 5212.519167985251)

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        
    }
    let homeVM = HomeViewModel()
    let tableRow = BusinessSearchRow(
        id: "AUbKbVQAUNI6Vr6LYtOZzA",
        alias: "california-donuts-los-angeles-2",
        name: "SK Donuts & Croissant",
        imageURL: "https://s3-media2.fl.yelpcdn.com/bphoto/f4qoSJYs1SFdOU2pYaGMWQ/o.jpg",
        isClosed: false,
        url:"https://www.yelp.com/biz/california-donuts-los-angeles-2?adjust_creative=53JdP5ZjnkJIAgHQCqUXNw&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=53JdP5ZjnkJIAgHQCqUXNw",
        reviewCount: 3001,
        categories: [Category(alias: "bakeries", title: "Bakeries"),Category(alias: "donuts", title: "Donuts"), Category(alias: "coffee", title: "Coffee & Tea")],
        rating: 4,
        coordinates: Coordinates(latitude: 34.068796, longitude: -118.293089),
        transactions: [Transaction.delivery,Transaction.pickup],
        price: "$$",
        location: LocationSearch(
            address1: "3540 W 3rd St",
            address2: "",
            address3: "",
            city: "Los Angeles",
            zipCode: "90020",
            country: "US",
            state: "CA",
            displayAddress: ["3540 W 3rd St","Los Angeles, CA 90020"]),
        phone: "+12133853318",
        displayPhone: "(213) 385-3318",
        distance: 5212.519167985251)
    let business = BusinessSearch(businesses: [inputRow], total: 1)
    
    let review: Review = Review(rating: 5,
                                userName: "Monica C.",
                                text: "Came here on a whim because my boyfriend and I both had a sweet tooth, and were both craving something sweet. So we both looked up dessert spots that were...",
                                timeCreated: "2022-11-27 00:15:40"
    )
    let reservationDetails: [ReservationDetails] = [
        ReservationDetails(business_id: "EXcTXl7UynFuaXGIiRCQAg", business_name: "Spudnuts Donuts", email: "abc@gmail.com", date: Date(), hours: "10", minute: "00"),
        ReservationDetails(business_id: "AUbKbVQAUNI6Vr6LYtOZzA", business_name: "California Donuts", email: "abc@gmail.com", date: Date(), hours: "10", minute: "30"),
        ReservationDetails(business_id: "8Ut_Ji14Vqg69QNd37V6Tg", business_name: "Donut Friend", email: "test@usc.edu", date: Date(), hours: "13", minute: "45")
    ]
    let loc = Location(lat: 34.0223519, lng: -118.285117)
}
