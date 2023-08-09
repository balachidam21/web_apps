//
//  SearchFormViewModel.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var search: Search = .empty
    
    var isValid: Bool{
        !search.keyword.isEmpty &&
        !search.distance.isEmpty &&
        !search.category.isEmpty &&
        (!search.location.isEmpty || search.getLocation)
    }
    @Published var searchResults: BusinessSearch? = nil
    @Published var showResultProgress: Bool = true
    @Published var autoComplete: Autocomplete? = nil
    private let searchService = BusinessSearchService()
    private let locationService = LocationService()
    private let autocompleteService  = AutoCompleteService()
    private var ipInfoLoc: IPInfo? = nil
    private var geoCodeLoc: Geocode? = nil
    
    @Published var coordinates: Location? = nil
    private var cancellable = Set<AnyCancellable>()
    private var firstCancellable = Set<AnyCancellable>()
    
    init(){
        
    }
    func clearDetails(){
        self.search = .empty
        self.searchResults = nil
        self.addAutoCompletePublisher()
        
    }
    private func addAutoCompletePublisher(){
        autocompleteService.$autocomplete
            .sink { (returnedDetails) in
                self.autoComplete = returnedDetails
            }
            .store(in: &firstCancellable)
        
    }
    func getAutoComplete(text: String)
    {
        self.autoComplete = nil
        autocompleteService.getAutocomplete(text: text)
        self.autocompleteService.$autocomplete
            .sink(receiveCompletion: { (_) in
                
            }, receiveValue: { [weak self] (returnedResults) in
                self?.autoComplete = returnedResults
            })
            .store(in: &self.firstCancellable)
    }
    func getBusinessSearch() {
        self.showResultProgress = true
        self.searchResults = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coordinates = nil
            Task{
                if self.search.getLocation{
                    if let ipinfo = await self.locationService.getLocationfromIP(){
                        self.ipInfoLoc = ipinfo
                        print(self.ipInfoLoc ?? "Did not receive")
                    }
                    
                    if let coord = self.ipInfoLoc?.location {
                        self.coordinates = coord
                        print(self.coordinates ?? "Did not recieve")
                    }
                }
                else {
                    if let geocode = await self.locationService.getLocationfromGeoCode(location: self.search.location) {
                        self.geoCodeLoc = geocode
                    }
                    
                    if let coord = self.geoCodeLoc?.results{
                        self.coordinates = coord[0].geometry?.location!
                    }
                }
                if let loc = self.coordinates {
                    await self.searchService.getSearch(search: self.search, location: loc)
                }
            }
            self.searchService.$searchResults
                .sink(receiveCompletion: { (_) in
                    
                }, receiveValue: { [weak self] (returnedResults) in
                    self?.searchResults = returnedResults
                })
                .store(in: &self.cancellable)
            self.showResultProgress = false
        }
    }
    
    
}
