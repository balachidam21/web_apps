//
//  YelpReviewApp.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import SwiftUI

@main
struct YelpReviewApp: App {
    @AppStorage("myReservation") var app: Data = Data()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
