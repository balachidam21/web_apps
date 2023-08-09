//
//  BusinessSearchService.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation
import Combine

import Alamofire
class BusinessSearchService {
    @Published var searchResults: BusinessSearch?
    var resultSubscription: AnyCancellable?
    
    init() {
        self.searchResults = nil
    }
    
    func getSearch(search: Search, location: Location)
    {
        let keyword = search.keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let category = search.category
        let radius = search.distance
        let lat = location.lat
        let lng = location.lng
        guard let url = URL(string: "https://webtech-fall22-node.uc.r.appspot.com/yelp/search?keyword=\(keyword)&latitude=\(lat!)&longitude=\(lng!)&categories=\(category)&radius=\(radius)") else {  return}
        print("Business Search: ",url)
        AF.request(url)
                .validate()
                .responseDecodable(of: BusinessSearch.self) { (data) in
                    guard let results = data.value else {return}
                    self.searchResults = results
                }
        }
}
