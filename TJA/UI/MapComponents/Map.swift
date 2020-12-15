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
    
    @Binding var places: [Activity]
    @Binding var selectedPlace: Place?
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
        map.register(PlaceAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        map.register(ClusterAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<Map>) {
        if uiView.userTrackingMode != locationService.userTrackingMode {
            uiView.setUserTrackingMode(locationService.userTrackingMode, animated: true)
        }
        updateAnnotations(from: uiView)
    }
    
    // MARK: - Map Coordinator -
    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var controller: Map
        
        init(_ controller: Map) {
            self.controller = controller
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("DEBUG: -- Map -- Selected annotation")
            guard let v = view.annotation as? Place else { return }
//            if self.controller.selectedPlace?.activity.id != v.activity.id {
//                DispatchQueue.main.async {
//                    self.controller.selectedPlace = v
//                }
//                
//            }
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            print("DEBUG: -- Map -- Changed MKUserTrackingMode to=\(mode.rawValue)")
            DispatchQueue.main.async {
//                self.controller.$userTrackingMode.wrappedValue = mode
                self.controller.locationService.userTrackingMode = mode
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? Place else { return nil }
            return PlaceAnnotation(annotation: annotation, reuseIdentifier: PlaceAnnotation.reuseId)
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
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let newAnnotations = places.compactMap{ Place($0) }
        mapView.addAnnotations(newAnnotations)
        if let selectedAnnotation = newAnnotations.filter({ $0.activity.id == selectedPlace?.activity.id }).first {
            mapView.selectAnnotation(selectedAnnotation, animated: true)
        }
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map(
//            userTrackingMode: .constant(.follow),
            places: .constant([]), selectedPlace: .constant(nil), tripLocation: CLLocationCoordinate2D(latitude: 40.71, longitude: -74)
        ).environmentObject(LocationService())
    }
}
