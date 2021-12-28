//
//  MapViewModel.swift
//  SwiftUI-User-Location
//
//  Created by James Boyer on 12/27/21.
//





import MapKit
// setup Map Details so the implementation below isn't so messy

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let span = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // var that holds the region, defaults with starting location
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.span)
    
    // location manager, optional, might not have it if user has given permissions
    var locationManager: CLLocationManager?
    
    // fired off when Map component Appears on View
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            // initialize location manager variable if the services are enabled
            locationManager = CLLocationManager()
            // unpacking, we shouldn't get in the habit of doing this...
            locationManager!.delegate = self
        } else {
            // an Alert would be better here, print to start
            print("Show an alert letting them know this is off and to go turn it back on.")
        }
    }
    
    
    private func checkLocationAuthorization() {
        // fail quickly if we don't have a location manager
        guard let locationMananger = locationManager else { return }
        
        // check location manager status, and do something about it!
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
    
    // this is some magic i don't fully understand but it some how watches for when location manager
    // get intialized and then fires off the callback passed in, in this case the function above
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
