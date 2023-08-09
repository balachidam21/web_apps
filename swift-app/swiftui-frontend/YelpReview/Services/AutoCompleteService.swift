//
//  File.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 12/8/22.
//

import Foundation
import Combine

import Alamofire
class AutoCompleteService {
    @Published var autocomplete: Autocomplete? = nil
    var resultSubscription: AnyCancellable?
    
    
    func getAutocomplete(text:String)
    {
        guard let url = URL(string: "https://webtech-fall22-node.uc.r.appspot.com/yelp/autocomplete?text=\(text)") else {  return}
        print("Autocomplete: ",url)
        AF.request(url)
            .validate()
            .responseDecodable(of: Autocomplete.self) { (data) in
                guard let results = data.value else {return}
                self.autocomplete = results
                print(self.autocomplete)
            }
        
    }
    
}
