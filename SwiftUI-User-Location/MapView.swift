//
//  MapView.swift
//  SwiftUI-User-Location
//
//  Created by James Boyer on 12/27/21.
//


// Content View renders the map view
// onAppear modifier on the Map component fires off the checkIfLocationServicesIsEnabled() function
// if the location services are enabled then we create a location manager
// when a location manager is created we fire off locationManagerDidChangeAuthorization
// that fires off checkLocationAuthorization and responds with an alert asking for permission
// or passes

import SwiftUI
import MapKit

struct MapView: View {
        
    @StateObject private var viewModel = ContentViewModel()
    
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{
                viewModel.checkIfLocationServicesIsEnabled()
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
        span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
        )
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Show an alert letting them know this is off and to go turn it back on.")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationMananger = locationManager else { return }
        
        switch locationMananger.authorizationStatus {
            
        case .notDetermined:
            locationMananger.requestWhenInUseAuthorization()
        case .restricted:
            print("You location is restricted, likely due to parental controls")
        case .denied:
            print("You have denied this app location permission, go into settings to change it")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: locationMananger.location!.coordinate.latitude,
                    longitude: locationMananger.location!.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
