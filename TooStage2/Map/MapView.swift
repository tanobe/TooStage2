//
//  MapView.swift
//  TooStage2
//
//  Created by Yuanfan Wang on 2021/03/16.
//

import SwiftUI
import MapKit
import Foundation
import Combine

struct SFSymbolOnMapView: View {
    var systemName: String
    var req: Int
    var ann: Int
    
    func isThere(count: Int) -> Bool {
        if count != 0 {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            switch systemName {
            case "cart":
                Image(systemName: systemName)
                    .padding(.top, 14)
                    .padding(.bottom, 12)
                    .padding(.leading, 12)
                    .padding(.trailing, 14)
                    .font(Font.title2.weight(.semibold))
                    .background(Color.white)
                    .foregroundColor(Color("color2"))
                    .clipShape(Circle())
                    .shadow1(radius: 2)
            case "24.custom":
                Image("24.custom")
                    .padding(.leading, 12.5)
                    .padding(.trailing, 15.5)
                    .padding(.vertical, 13)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow1(radius: 2)
            default:
                Image(systemName: systemName)
                    .padding(13)
                    .font(Font.title2.weight(.semibold))
                    .background(Color.white)
                    .foregroundColor(Color("color2"))
                    .clipShape(Circle())
                    .shadow1(radius: 2)
            }
            

            switch (isThere(count: req), isThere(count: ann)) {
            case (true, true):
                Circle().fill(Color("yellow1"))
                    .frame(width: 12, height: 12)
                    .offset(x: 26, y: -4)
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 8))
                    .frame(width: 20, height: 20)
                    .background(Color("yellow1"))
                    .foregroundColor(Color("color1"))
                    .clipShape(Circle())
                    .offset(x: 20, y: -22)
            case (true, false):
                Circle().fill(Color("yellow1"))
                    .frame(width: 20, height: 20)
                    .offset(x: 20, y: -22)
            case (false, true):
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 8))
                    .frame(width: 20, height: 20)
                    .background(Color("yellow1"))
                    .foregroundColor(Color("color1"))
                    .clipShape(Circle())
                    .offset(x: 20, y: -22)
            case (false, false):
                EmptyView()
            }
            
            
        }
    }
}


struct MapView: View {
    
    @ObservedObject var shops = Shops.shared.shops
    @StateObject var location = Location.shared
    @StateObject var shopDetail = ShopDetail.shared
    
    @Binding var status: TabList
    
    // for tutorial
    @State var lightbulb = false
    
    var body: some View {
            ZStack {
                Map(coordinateRegion: $location.region,
                    showsUserLocation: true,
                    annotationItems: shops.list,
                    annotationContent:
                        { shop in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: shop.geopoint["lat"] ?? 0, longitude: shop.geopoint["lon"] ?? 0)) {
                                SFSymbolOnMapView(systemName: shop.sfSymbol, req: shop.requests.reqList.count, ann: shop.announce.annList.count)
                                    .onTapGesture {
                                        self.shopDetail.shop(shop)
                                        self.shopDetail.showSheet()
                                    }
                            }
                    }
                )
                
                // MARK: - tutorial
                VStack {
                    HStack {
                        Button(action: {
                            self.lightbulb = true
                        }, label: {
                            ZStack {
                                Circle().strokeBorder(Color("black1"), lineWidth: 1.5)
                                    .frame(width: 35, height: 35)
                                Image(systemName: "lightbulb")
                                    .foregroundColor(Color("black1"))
                                    .font(.system(size: 18))
                            }
                        })
                        .padding(.leading, 30)
                        .padding(.top, 70)
                        .sheet(isPresented: $lightbulb, content: {
                            let pages = [
                                TutorialImageView(image: Image("tutorial1")),
                                TutorialImageView(image: Image("tutorial2")),
                                TutorialImageView(image: Image("tutorial3")),
                                TutorialImageView(image: Image("tutorial4")),
                                TutorialImageView(image: Image("tutorial5")),
                            ]
                            TutorialView(pages: pages)
                        })
                        
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.status = .ano
                        }, label: {
                            Image("campaign")
                                .resizable()
                                .frame(width: 110, height: 62)
                                .shadow1(radius: 10)
                        })
                    }
                    Spacer()
                }
                .padding(.top, 60)
                
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
    }
}


class Location: ObservableObject {
    
    static let shared = Location()
    
    @Published var region = MKCoordinateRegion (
        center: CLLocationCoordinate2D (
            latitude: LocationManager.shared.userLatitude,
            longitude: LocationManager.shared.userLongitude),
        latitudinalMeters: 410,
        longitudinalMeters: 410)
    
    func push(lat: Double, lon: Double) {
        self.region = MKCoordinateRegion (
            center: CLLocationCoordinate2D (
                latitude: lat,
                longitude: lon),
            latitudinalMeters: 410,
            longitudinalMeters: 410)
    }
}

class LocationManager: NSObject, ObservableObject{
    
    static let shared = LocationManager()
  
    // not zero at first
    var userLatitude: Double = 35.641811414391015
    var userLongitude: Double = 139.28270268219757
    
    private let locationManager = CLLocationManager()

    override init() {
//        print("*********\nLocationManeger init\n*************")
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.userLatitude = [CLLocation]().last?.coordinate.latitude ?? 35.641811414391015
        self.userLongitude = [CLLocation]().last?.coordinate.longitude ?? 139.28270268219757
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
//        print(location)
    }
}
