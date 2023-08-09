//
//  ContentView.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                HomeView()
                    .navigationTitle("Business Search")
                    .navigationBarItems(
                        trailing: NavigationLink(
                            destination: ReservationView()
                                .navigationTitle("Your Reservations")
                                , label: {
                            Image(systemName: "calendar.badge.clock")
                        }))

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
