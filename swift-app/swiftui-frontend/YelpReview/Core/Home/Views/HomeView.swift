//
//  HomeView.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/24/22.
//

import SwiftUI
import UIKit

func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    return .none
}

extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}


struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var showResult: Bool = false
    @State var showAutoComplete = false
    var body: some View {
        Form{
            Section{
                searchForm
            }
            Section{
                businessResults
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Business Search")
                .navigationBarItems(
                    trailing: NavigationLink(
                        destination: ReservationView()
                        , label: {
                            Image(systemName: "calendar.badge.clock")
                        }))
        }
    }
}

extension HomeView {
    var submitBackground: Color{
        return viewModel.isValid ? .red : .gray
    }
    private var searchForm: some View {
        List{
            HStack{
                Text("Keyword:")
                    .foregroundColor(.gray)
                TextField(text: $viewModel.search.keyword) {
                    Text("Required")
                }
                .onChange(of: viewModel.search.keyword, perform: { newValue in
                    showAutoComplete = false
                })
                .onSubmit {
                    showAutoComplete = true
                    viewModel.getAutoComplete(text: viewModel.search.keyword)
                }
            }
            .alwaysPopover(isPresented: $showAutoComplete){
                if (viewModel.autoComplete != nil){
                    if let suggestions = viewModel.autoComplete?.suggestions {
                        ForEach(suggestions, id:\.self) {
                            a in
                            Button(a.text){
                                viewModel.search.keyword = a.text
                            }
                            .foregroundColor(.gray)
                        }
                    }
                }
                else {
                    ProgressView("loading...")
                }
            }
            
            HStack{
                Text("Distance:")
                    .foregroundColor(.gray)
                TextField(text: $viewModel.search.distance) {
                    Text("Required")
                }
            }
            
            HStack{
                Text("Category:")
                    .foregroundColor(.gray)
                
                Picker("", selection: $viewModel.search.category) {
                    Text("Default").tag("all")
                    Text("Arts and Entertainment").tag("arts")
                    Text("Health and Medical").tag("health")
                    Text("Hotels and Travel").tag("hotelstravel")
                    Text("Food").tag("food")
                    Text("Professional Services").tag("professional")
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            if !viewModel.search.getLocation{
                HStack{
                    Text("Location:")
                        .foregroundColor(.gray)
                    TextField(text: $viewModel.search.location) {
                        Text("Required")
                    }
                }
            }
            
            HStack{
                Toggle("Auto-detect my location:", isOn: $viewModel.search.getLocation)
                    .onChange(of: viewModel.search.getLocation, perform: { newValue in
                        if viewModel.search.getLocation {
                            viewModel.search.location = ""
                        }
                    })
                    .foregroundColor(.gray)
            }
            
            
            HStack{
                Spacer()
                Text("Submit")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .background(
                        submitBackground
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        showResult = true
                        Task{
                            viewModel.getBusinessSearch()
                        }
                    }
                    .disabled(!viewModel.isValid)
                Spacer()
                Text("Clear")
                    .foregroundColor(.white)
                    .padding(.vertical,10)
                    .padding(.horizontal, 32)
                    .background(
                        Color.blue
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        showResult = false
                        viewModel.clearDetails()
                        
                    }
                Spacer()
            }
            
        }
    }
    
    private var businessResults: some View{
        List{
            Text("Results")
                .font(.title)
                .fontWeight(.bold)
            
            
            if showResult{
                //                if viewModel.showResultProgress{
                //                    resultsProgress
                //                }
                //                if !viewModel.showResultProgress, let results = viewModel.searchResults{
                //                    if results.total > 0 {
                //                        ForEach(results.businesses.indices, id:\.self) {i in
                //                            BusinessTableRow(rowID: i+1, row: results.businesses[i])
                //                        }
                //                    } else{
                //                        errorView
                //                    }
                //                }
                if (viewModel.searchResults != nil) {
                    if let results = viewModel.searchResults {
                        if results.total > 0 {
                            ForEach(results.businesses.indices, id:\.self) {
                                i in
                                BusinessTableRow(rowID: i+1, row: results.businesses[i])
                            }
                        }else{
                            errorView
                        }
                    }else
                    {
                        errorView
                    }
                }
                else
                {
                    resultsProgress
                }
            }
            //            if showResult{
            //                if viewModel.showResultProgress{
            //                    resultsProgress
            //                }
            //                else if !viewModel.showResultProgress{
            //                    if viewModel.searchResults.total > 0 {
            //                       resultsTable
            //                    } else if viewModel.searchResults.total == 0{
            //                        errorView
            //                    }
            //                }
            //            }
        }
    }
    
    var resultsProgress : some View {
        HStack{
            Spacer()
            ProgressView("Please wait...")
            Spacer()
        }
    }
    
    var errorView : some View {
        Text("No result available")
            .foregroundColor(.red)
            .font(.subheadline)
    }
    
}


