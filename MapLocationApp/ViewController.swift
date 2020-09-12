//
//  ViewController.swift
//  MapLocationApp
//
//  Created by Mithun Raj on 12/09/20.
//  Copyright © 2020 Mithun Raj. All rights reserved.
//

import Cocoa
import MapKit

class ViewController: NSViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: NSTextField!
    
    var locationManager = CLLocationManager()
    var recogniser: NSClickGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = 10
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        recogniser = NSClickGestureRecognizer(target: self, action: #selector(locationClicked))
        recogniser?.numberOfClicksRequired = 1
        mapView.addGestureRecognizer(recogniser!)
    }
    
    @objc func locationClicked() {
        guard let mouseClickLocation = recogniser?.location(in: mapView) else { return }
        let coordinate = mapView.convert(mouseClickLocation, toCoordinateFrom: mapView)
        setAddress(coordinate: coordinate)
    }
    
    func setAddress(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            if error == nil {
                let placemark = placemark?.first
                let address = placemark?.name
                DispatchQueue.main.async {
                    self.addressLabel.stringValue = address ?? ""
                }
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let coordinate = location?.coordinate else { return }
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

