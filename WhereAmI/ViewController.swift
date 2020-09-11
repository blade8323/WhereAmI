//
//  ViewController.swift
//  WhereAmI
//
//  Created by Владислав Соколов on 09.09.2020.
//  Copyright © 2020 Владислав Соколов. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var previousPoint: CLLocation?
    private var totalMovementDistance = CLLocationDistance(0)
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var verticalAccuracyLabel: UILabel!
    @IBOutlet var distanceTraveledLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(title: "Location Manager Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            let lattitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
            latitudeLabel.text = lattitudeString
            let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
            longitudeLabel.text = longitudeString
            let horizontalAccuracyString = String(format: "%gm", newLocation.horizontalAccuracy)
            horizontalAccuracyLabel.text = horizontalAccuracyString
            let altitudeString = String(format: "%gm", newLocation.altitude)
            altitudeLabel.text = altitudeString
            let verticalAccuracyString = String(format: "%gm", newLocation.verticalAccuracy)
            verticalAccuracyLabel.text = verticalAccuracyString
            
            if newLocation.horizontalAccuracy < 0 {
                //неприемлимая точность
                return
            }
            
            if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {
                //диапазон точности велик, что пользовать его не стоит
                return
            }
            
            if previousPoint == nil {
                totalMovementDistance = 0
                let start = Place(title: "Start Point", subtitle: "This is there we started", coordinate: newLocation.coordinate)
                mapView.addAnnotation(start)
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
                mapView.setRegion(region, animated: true)
            } else {
                print("movement distance: \(newLocation.distance(from: previousPoint!))")
                totalMovementDistance += newLocation.distance(from: previousPoint!)
            }
            previousPoint = newLocation
            
            let distanceString = String(format: "%gm", totalMovementDistance)
            distanceTraveledLabel.text = distanceString
        }
    }

}

