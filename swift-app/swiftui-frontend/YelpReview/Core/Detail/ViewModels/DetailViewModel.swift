//
//  DetailViewModel.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/26/22.
//

import Foundation
import Combine
import SwiftUI

class DetailViewModel: ObservableObject {
    let business: BusinessSearchRow
    private let businessDetailService: BusinessDetailService
    private var firstCancellable = Set<AnyCancellable>()
    private var secondCancellable = Set<AnyCancellable>()
    
    @Published var businessDetail: BusinessDetail? = nil
    @Published var businessReview: BusinessReview? = nil
    @Published var showResultsProgress: Bool = true
    @Published var reservationEmail: String = ""
    @Published var date = Date()
    @Published var hour: String = "10"
    @Published var minute: String = "00"
    @Published var showToast: Bool = false
    @Published var showSuccessMessage: Bool = false
    @Published var isEmailValid = false
    @Published var reservationDetails: [ReservationDetails] = []
    @Published var showCancelButton: Bool = false
    @AppStorage("myReservation") var app: Data?
    @Published var showCancelToast = false
    private var publishers = Set<AnyCancellable>()
    init(business: BusinessSearchRow) {
        self.business = business
        self.businessDetailService = BusinessDetailService(business: business)
        self.addDetails()
        self.showResultsProgress = true
        self.reservationEmail = ""
        isEmailValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isEmailValid, on: self)
            .store(in: &publishers)
        self.reservationDetails =  ReservationStorage.getReservations()
        self.checkForReservation()
        print(self.reservationDetails)
    }
    
    private func addDetails(){
        businessDetailService.$businessDetail
            .sink { (returnedDetails) in
                self.businessDetail = returnedDetails
            }
            .store(in: &firstCancellable)
        
    }
    func enableProgress(){
        self.showResultsProgress = true
    }
    func disableProgress(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.businessDetailService.$businessReview
                .sink { (returnedReviews) in
                    self.businessReview =  returnedReviews
                }
                .store(in: &self.secondCancellable)
        }
    }
    //    private func getReservations(){
    //        if let reservations = try? JSONDecoder().decode([ReservationDetails].self, from: app ?? Data()) {
    //            self.reservationDetails = reservations
    //        }
    //    }
    func addReservation(businessId: String, businessName:String, email:String, date:Date, hour:String, minute:String){
        let newReservation: ReservationDetails = ReservationDetails(business_id: businessId, business_name: businessName, email: email, date: date, hours: hour, minute: minute)
        print(date)
        self.reservationDetails.append(newReservation)
        ReservationStorage.storeReservations(reservationDetails: self.reservationDetails)
        self.showCancelButton = true
        self.showSuccessMessage = true
    }
    //    private func storeReservations(){
    //        if let reservations = try? JSONEncoder().encode(self.reservationDetails) {
    //            self.app = reservations
    //        }
    //    }
    func checkForReservation(){
        for reservation in self.reservationDetails {
            if reservation.business_id == self.business.id{
                print(reservation)
                self.showCancelButton = true
                break
            }
        }
    }
    func cancelReservation(id: String){
        let filtered = self.reservationDetails.filter { reservation in
            return reservation.business_id != id
        }
        
        self.reservationDetails = filtered
        ReservationStorage.storeReservations(reservationDetails: self.reservationDetails)
        self.resetReservationSheet()
        self.showCancelButton  = false
        self.showCancelToast = true
    }
    func resetReservationSheet(){
        self.reservationEmail =  ""
        self.date = Date()
        self.hour = "10"
        self.minute = "00"
        self.showSuccessMessage = false
        
    }
}
private extension DetailViewModel{
    var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $reservationEmail
            .map{
                email in
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
                return emailPredicate.evaluate(with: email)
            }
            .eraseToAnyPublisher()
    }
}
