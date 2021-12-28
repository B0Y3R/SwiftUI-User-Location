//
//  MapView.swift
//  SwiftUI-User-Location
//
//  Created by James Boyer on 12/27/21.
//


// Take the ViewModel
// use it to pass in the coordinates for the region in the Map
// onAppear run the checkIfLocaitonServicesIsEnabled
// if location services are enabled, veiwModel.region will change to the users current location


import MapKit
import SwiftUI

struct MapView: View {
        
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear{ viewModel.checkIfLocationServicesIsEnabled() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
