//
//  GoogleMapView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D

    private let mapView = GMSMapView(frame: .zero)
    private let zoomLevel: Float = 18

    private var marker: GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.isDraggable = true
        marker.appearAnimation = .pop
        return marker
    }

    let onAnimationEnded: (CLLocationCoordinate2D) -> Void

    func makeUIView(context: Context) -> GMSMapView {
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoomLevel)
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true

        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.animate(toLocation: coordinate)
        uiView.clear()
        marker.map = uiView
    }

    func makeCoordinator() -> GoogleMapViewCoordinator {
        GoogleMapViewCoordinator(self)
    }

    final class GoogleMapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView

        init(_ mapView: GoogleMapView) {
            self.mapView = mapView
        }

        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            self.mapView.onAnimationEnded(marker.position)
        }
    }
}
