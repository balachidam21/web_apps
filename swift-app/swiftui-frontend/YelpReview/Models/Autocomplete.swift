//
//  AutocompleteModel.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation

struct Autocomplete: Codable {
    let suggestions: [Suggestion]?
}

struct Suggestion: Codable, Hashable {
    let text: String
}
