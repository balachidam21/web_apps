//
//  BusinessReview.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation

/*
 {
     "reviews": [
         {
             "rating": 5,
             "user_name": "Alejandra L.",
             "text": "Absolutely delicious. Each hand roll was made perfectly and we were excited for each roll, and none disappointed. Great ambiance and the service is super...",
             "time_created": "2022-10-17 00:40:08"
         },
         {
             "rating": 5,
             "user_name": "Gina O.",
             "text": "This location has the best hand rolls! \n\nI've never experienced anything like this before! The seaweed and rice are served warm and the fish inside tasted...",
             "time_created": "2022-11-22 07:27:55"
         },
         {
             "rating": 3,
             "user_name": "Celine C.",
             "text": "Scrolled thru the DineLA list and decided on KazuNori for the $25 dinner menu (salmon sashimi + toro, yellowtail, scallop, crab, and lobster handroll). I've...",
             "time_created": "2022-11-21 13:29:29"
         }
     ]
 }
 */
struct BusinessReview: Codable {
    let reviews: [Review]?
}

struct Review: Codable, Hashable {
    let rating: Int?
    let userName, text, timeCreated: String?

    enum CodingKeys: String, CodingKey {
        case rating
        case userName = "user_name"
        case text
        case timeCreated = "time_created"
    }
}
