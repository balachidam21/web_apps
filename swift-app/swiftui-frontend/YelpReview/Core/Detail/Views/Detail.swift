//
//  BusinessDetail.swift
//  YelpReview
//
//  Created by Balaji Chidambaram on 11/26/22.
//

import SwiftUI
import Kingfisher
import MapKit

struct Detail: View {
    @StateObject var viewModel: DetailViewModel
    
    init(business: BusinessSearchRow){
        _viewModel = StateObject(wrappedValue: DetailViewModel(business: business))
    }
    var body: some View {
        TabView {
            DetailsTab()
                .tabItem {
                    Label("Business Detail", systemImage: "text.bubble.fill")
                }
            MapLocationTab()
                .tabItem {
                    Label("Map Location", systemImage: "location.fill")
                }
            ReviewsTab()
                .tabItem {
                    Label("Reviews", systemImage: "message.fill")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(viewModel)
    }
}

struct BusinessDetail_Previews: PreviewProvider {
    
    static var previews: some View {
        Group{
            Detail(business: dev.tableRow)
            ReservationSheet()
                .environmentObject(DetailViewModel(business: dev.tableRow))
        }
    }
}

struct DetailsTab: View {
    @EnvironmentObject var viewModel: DetailViewModel
    @State private var showingSheet = false
    var body: some View{
        if (viewModel.businessDetail != nil) {
            VStack{
                Text(viewModel.businessDetail?.name ?? "")
                    .font(.title)
                    .bold()
                    .padding()
                //            detailStack
                detailStack2
                reservationButton
                    .padding()
                shareButtons
                imageTab
                    .padding()
                Spacer()
            }
            .padding()
            .toast(isPresented: $viewModel.showCancelToast) {
                Text("Your reservation is cancelled")
            }
            
        }
        else {
            HStack{
                Spacer()
                ProgressView {
                    Text("Please wait...")
                }
                .progressViewStyle(.circular)
                Spacer()
            }
            
        }
    }
    
}

extension DetailsTab {
    private var detailStack: some View{
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 15){
                VStack(alignment: .leading){
                    Text("Address")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.location?.fullAddress ?? "NA")
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading){
                    Text("Phone")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.displayPhone ?? "NA")
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading){
                    Text("Status")
                        .fontWeight(.bold)
                    if let hour = viewModel.businessDetail?.hours{
                        if hour[0].isOpenNow!{
                            Text("Open Now")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Closed")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            VStack(alignment: .trailing, spacing: 15) {
                VStack(alignment: .trailing) {
                    Text("Category")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.allCategories ?? "NA")
                        .foregroundColor(.gray)
                }
                VStack(alignment: .trailing) {
                    Text("Price Range")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.price ?? "NA")
                        .foregroundColor(.gray)
                }
                VStack(alignment: .trailing) {
                    Text("Visit Yelp for more")
                        .fontWeight(.bold)
                    if let url = viewModel.businessDetail?.url{
                        Link("Business Link", destination: URL(string: url)!)
                    }
                }
                
                
            }
        }
    }
    private var detailStack2: some View {
        VStack(spacing: 15) {
            HStack() {
                VStack(alignment: .leading) {
                    Text("Address")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.location?.fullAddress ?? "NA")
                        .foregroundColor(.gray)
                        .frame(maxWidth:200,alignment: .leading)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Category")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.allCategories ?? "NA")
                        .foregroundColor(.gray)
                }
            }
            HStack() {
                VStack(alignment: .leading){
                    Text("Phone")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.displayPhone ?? "NA")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Price Range")
                        .fontWeight(.bold)
                    Text(viewModel.businessDetail?.price ?? "NA")
                        .foregroundColor(.gray)
                }
            }
            HStack() {
                VStack(alignment: .leading){
                    Text("Status")
                        .fontWeight(.bold)
                    if let hour = viewModel.businessDetail?.hours{
                        if hour[0].isOpenNow!{
                            Text("Open Now")
                                .foregroundColor(.green)
                        }
                        else{
                            Text("Closed")
                                .foregroundColor(.red)
                        }
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Visit Yelp for more")
                        .fontWeight(.bold)
                    if let url = viewModel.businessDetail?.url{
                        Link("Business Link", destination: URL(string: url)!)
                    }
                }
                
            }
        }
    }
    private var reservationButton: some View{
        ZStack{
            if viewModel.showCancelButton {
                cancelButton
                
            }
            if !viewModel.showCancelButton {
                reserveButton
            }
        }
    }
    private var reserveButton: some View{
        HStack{
            Spacer()
            Button {
                showingSheet.toggle()
            } label: {
                Text("Reserve Now")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(
                        Color.red
                            .cornerRadius(10)
                    )
            }
            .buttonStyle(.borderless)
            .sheet(isPresented: $showingSheet) {
                ReservationSheet()
            }
            Spacer()
        }
    }
    private var cancelButton: some View{
        HStack{
            Spacer()
            Button {
                if let id = viewModel.businessDetail?.id{
                    viewModel.cancelReservation(id: id)
                }
            } label: {
                Text("Cancel Reservation")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(
                        Color.blue
                            .cornerRadius(10)
                    )
            }
            .buttonStyle(.borderless)
            .sheet(isPresented: $showingSheet) {
                ReservationSheet()
            }
            Spacer()
        }
        
    }
    
    private var shareButtons: some View{
        HStack{
            Spacer()
            Text("Share on:")
                .fontWeight(.medium)
            if let name = viewModel.businessDetail?.name, let url = viewModel.businessDetail?.url {
                let splitarray = name.components(separatedBy: " ")
                let joinedName = splitarray.joined(separator: "%20")
                Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(url)")!) {
                    Image("facebook")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                Link(destination: URL(string: "https://twitter.com/intent/tweet?text=\(joinedName).&url=\(url)")!) {
                    Image("twitter")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            Spacer()
        }
    }
    
    private var imageTab: some View {
        TabView {
            if let photos = viewModel.businessDetail?.photos{
                ForEach(photos.indices, id: \.self) { i in
                    KFImage(URL(string: photos[i])!)
                        .resizable()
                        .frame(maxWidth: 300,maxHeight: 300)
                        .tag(i)
                        .tabItem {
                            Label("",systemImage: "circle")
                        }
                }
                
            }
        }
        .tabViewStyle(.page)
    }
}
struct Marker: Identifiable{
    let id = UUID()
    var location: MapMarker
}

struct MapLocationTab:View{
    @EnvironmentObject var viewModel: DetailViewModel
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    @State var mapCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var marker: Marker = Marker(location: MapMarker(coordinate: CLLocationCoordinate2D()))
    var body: some View{
        VStack{
            Map(coordinateRegion: $region,
                annotationItems: [marker]) {
                m in
                m.location
            }
        }.onAppear {
            if let coord = viewModel.businessDetail?.coordinates{
                self.region = MKCoordinateRegion(center: coord.mapCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                self.mapCoord = coord.mapCoordinate
                self.marker = Marker(location: MapMarker(coordinate: self.mapCoord, tint: .red))
            }
        }
    }
}

struct ReviewsTab:View{
    @EnvironmentObject var viewModel: DetailViewModel
    var body: some View{
        VStack{
            if (viewModel.businessReview == nil){
                ProgressView {
                    Text("Please wait...")
                }
            }else{
                showReviews
                Spacer()
            }
        }
        .onAppear{
            viewModel.disableProgress()
        }
    }
}

extension ReviewsTab{
    private var showReviews: some View{
        List{
            if let reviews = viewModel.businessReview?.reviews{
                ForEach(reviews, id:\.self) { review in
                    ReviewRow(row: review)
                }
            }
        }
    }
}

struct ReservationSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: DetailViewModel
    
    var body: some View{
        if !viewModel.showSuccessMessage{
            VStack{
                Form {
                    Section{
                        HStack{
                            Spacer()
                            Text("Reservation Form")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    Section{
                        HStack{
                            Spacer()
                            Text(viewModel.businessDetail?.name ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                    Section{
                        reservationForm
                    }
                }
                .toast(isPresented: $viewModel.showToast) {
                    Text("Please enter a valid email.")
                }
            }
        }
        if viewModel.showSuccessMessage{
            ZStack{
                Color.green
                    .ignoresSafeArea()
                VStack(spacing: 30){
                    Spacer()
                    Text("Congratulations!")
                    Text("You have successfully made an reservation at \(viewModel.businessDetail?.name ?? "")")
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(.green)
                            .padding(.vertical,15)
                            .padding(.horizontal, 60)
                            .background(
                                Color.white
                                    .cornerRadius(40)
                            )
                    }
                }
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center)
            }
            .onAppear(
                perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            dismiss()
                        }
                    }
                }
            )
        }
    }
    
}

extension ReservationSheet{
    private var reservationForm: some View {
        List {
            HStack{
                Text("Email:")
                    .foregroundColor(.gray)
                TextField(text: $viewModel.reservationEmail) {
                    Text("")
                }
            }
            HStack(spacing:0){
                Text("Date/Time:")
                    .foregroundColor(.gray)
                Spacer()
                
                DatePicker("",selection: $viewModel.date,
                           in: Date()...,
                           displayedComponents: .date
                )
                .labelsHidden()
                .frame(width:20, alignment: .trailing)
                .padding()
                HStack{
                    Picker(selection: $viewModel.hour) {
                        Text("10").tag("10")
                        Text("11").tag("11")
                        Text("12").tag("12")
                        Text("13").tag("13")
                        Text("14").tag("14")
                        Text("15").tag("15")
                        Text("16").tag("16")
                        Text("17").tag("17")
                    } label:{
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .tint(Color.black)
                    .padding(.leading,-11)
                    Text(":")
                    Picker("", selection: $viewModel.minute) {
                        Text("00").tag("00")
                        Text("15").tag("15")
                        Text("30").tag("30")
                        Text("45").tag("45")
                    }
                    .pickerStyle(.menu)
                    .tint(Color.black)
                    .labelsHidden()
                    .padding(.leading,-15)
                }.background(Color.gray
                    .cornerRadius(10)
                    .opacity(0.2))
            }
            HStack{
                Spacer()
                Button {
                    if viewModel.isEmailValid{
                        //                            print(viewModel.reservationEmail, viewModel.businessDetail?.name)
                        if let businessId = viewModel.businessDetail?.id , let businessName = viewModel.businessDetail?.name {
                            viewModel.addReservation(businessId: businessId, businessName: businessName, email: viewModel.reservationEmail, date: viewModel.date, hour: viewModel.hour, minute: viewModel.minute)
                        }
                        
                    }
                    else{
                        withAnimation {
                            viewModel.showToast = true
                        }
                    }
                } label: {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .padding(.horizontal, 32)
                        .background(
                            Color.blue
                                .cornerRadius(15)
                        )
                }
                .buttonStyle(.borderless)
                .padding()
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}


//https://twitter.com/intent/tweet?text=Check%20{{businessDetail.name}}%20on%20Yelp.&url={{businessDetail.url}}

//https://www.facebook.com/sharer/sharer.php?u={{businessDetail.url}}

//                        let twitter_url = "https://twitter.com/intent/tweet?text=Check%20\(name)%20on%20Yelp.&url=\(url)"

//                        let facebook_url = "https://www.facebook.com/sharer/sharer.php?u=\(url)"
