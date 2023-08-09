//
//  SearchForm.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation

struct Search{
    var keyword: String
    var distance: String
    var category: String
    var location: String
    var getLocation: Bool
    
}

extension Search{
    static var empty: Search{
        return Search(
            keyword: "",
            distance: "10",
            category: "all",
            location: "",
            getLocation: false)
    }
}
