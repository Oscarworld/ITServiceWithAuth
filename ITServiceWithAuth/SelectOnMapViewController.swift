//
//  SelectOnMapViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 31.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SelectOnMapViewController: UIViewController {

    @IBOutlet weak var mapViewController: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var oldLat = 0.0
    var oldLon = 0.0
    var oldAddress = ""
    
    @IBAction func saveChange(sender: AnyObject) {
        boolLoc = true
        labelAddress = oldAddress
        createPos = CLLocationCoordinate2D(latitude: oldLat, longitude: oldLon)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewController.delegate = self
        mapViewController.myLocationEnabled = true
        mapViewController.settings.myLocationButton = true
        
        mapViewController.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locLat, longitude: locLon), zoom: 15, bearing: 0, viewingAngle: 0)
        
        addressLabel.text = oldAddress
    }
}

extension SelectOnMapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        mapView.camera = GMSCameraPosition(target: coordinate, zoom: mapViewController.camera.zoom, bearing: 0, viewingAngle: 0)
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.snippet = result?.title
        marker.map = mapView
        
        oldLat = coordinate.latitude
        oldLon = coordinate.longitude
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                self.addressLabel.text = lines.joinWithSeparator("\n")
                self.oldAddress = self.addressLabel.text!
                
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapViewController.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0,
                                                    bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}
