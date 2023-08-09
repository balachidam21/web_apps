//
//  BusinessDetailService.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/26/22.
//

import Foundation

import Foundation
import Combine
import Alamofire

class BusinessDetailService {
    @Published var businessDetail: BusinessDetail? = nil
    @Published var businessReview: BusinessReview? = nil
    var resultSubscription: AnyCancellable?
    let business: BusinessSearchRow
    init(business: BusinessSearchRow) {
        self.business = business
        getBusinessDetail()
        getBusinessReviews()
    }
    
    func getBusinessDetail()
    {
        guard let url = URL(string: "https://webtech-fall22-node.uc.r.appspot.com/yelp/business?business_id=\(business.id)") else {  return}
        print("Business Detail: ",url)
        Task{
            await AF.request(url)
                .validate()
                .responseDecodable(of: BusinessDetail.self) { (data) in
                    guard let results = data.value else {return}
                    self.businessDetail = results
                }
        }
    }
    func getBusinessReviews()
    {
        guard let url = URL(string: "https://webtech-fall22-node.uc.r.appspot.com/yelp/reviews?business_id=\(business.id)") else {  return}
        print("Business Review: ",url)
        Task{
            await AF.request(url)
                .validate()
                .responseDecodable(of: BusinessReview.self) { (data) in
                    guard let results = data.value else {return}
                    self.businessReview = results
                }
        }
        
    }
}
