//
//  LocationService.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/25/22.
//

import Foundation
import Combine

import Alamofire
class LocationService {
    @Published var ipInfo : IPInfo?
    @Published var geoCode: Geocode?
    var resultSubscription: AnyCancellable?
    
    init() {
        self.ipInfo = nil
    }
    
    func getLocationfromIP() async -> IPInfo?
    {
        guard let url = URL(string: "https://ipinfo.io/?token=76425a4da47e80") else {  return nil}
//        print("IPINFO: ", url)
        Task{
             AF.request(url)
                .validate()
                .responseDecodable(of: IPInfo.self) { (data) in
                    guard let results = data.value else {return}
                    self.ipInfo = results
                }
        }
            return self.ipInfo
            
            
        }
    
    func getLocationfromGeoCode(location: String) async -> Geocode? {
        let loc = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(loc)&key=AIzaSyCtVyR8_f2pS9QfSdOFLhTNqLwtBXI10Xw") else {  return nil}
        print("GEOCODE: ", url)
        Task {
            AF.request(url)
                .validate()
                .responseDecodable(of: Geocode.self) {
                    (data) in
                    guard let results = data.value else {return}
                    self.geoCode = results
                }
        }
        return self.geoCode
        
    }
}
