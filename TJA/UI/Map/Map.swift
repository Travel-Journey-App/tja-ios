//
//  Map.swift
//  TJA
//
//  Created by Miron Rogovets on 19.11.2020.
//  Copyright © 2020 MironRogovets. All rights reserved.
//

import SwiftUI
import MapKit

struct Map: UIViewRepresentable {
    
    @EnvironmentObject var locationService: LocationService
    var tripLocation: CLLocationCoordinate2D?
    
    func makeCoordinator() -> Map.Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<Map>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.userTrackingMode = locationService.userTrackingMode
        map.delegate = context.coordinator
        if let region = makeInitialRegion() {
            map.setRegion(region, animated: true)
        }
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<Map>) {
        if uiView.userTrackingMode != locationService.userTrackingMode {
            uiView.setUserTrackingMode(locationService.userTrackingMode, animated: true)
        }
    }
    
    // MARK: - Map Coordinator -
    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var controller: Map
        
        init(_ controller: Map) {
            self.controller = controller
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("DEBUG: -- Map -- Selected annotation")
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            print("DEBUG: -- Map -- Added annotations")
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            print("DEBUG: -- Map -- Changed MKUserTrackingMode to=\(mode.rawValue)")
            DispatchQueue.main.async {
//                self.controller.$userTrackingMode.wrappedValue = mode
                self.controller.locationService.userTrackingMode = mode
            }
        }
    }
    
    // MARK: - Private -
    private func makeInitialRegion() -> MKCoordinateRegion? {
        if let location = tripLocation {
            return MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
            )
        } else {
            return nil
        }
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map(
//            userTrackingMode: .constant(.follow),
            tripLocation: CLLocationCoordinate2D(latitude: 40.71, longitude: -74)
        ).environmentObject(LocationService())
    }
}
