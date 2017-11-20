//
//  OnMapViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 26.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import ARSLineProgress
import CoreLocation

class OnMapViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, GMSMapViewDelegate {

    @IBOutlet weak var radius: UISlider!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceField: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var mapViewController: GMSMapView!
    
    var selected = "Все категории"
    var mapResult = [DataResult]()
    let rangeSlider1 = RangeSlider(frame: CGRectZero)
    var first = true
    
    @IBAction func changeRait(sender: AnyObject) {
        radius.value = round(radius.value / 100) * 100
        ratingLabel.text = "\(String(Int(radius.value))) м."
        
        self.mapViewController.clear()
        
        for (_, element) in self.mapResult.enumerate() {
            if (element.lat != "" || element.lon != "") {
                if (self.distans(locLat, lon: locLon, cLat: Double(element.lat)!, cLon: Double(element.lon)!) < Double(self.radius.value)) {
                    let marker = GMSMarker()
                    
                    marker.position = CLLocationCoordinate2D(latitude: Double(element.lat)!, longitude: Double(element.lon)!)
                    marker.userData = element
                    marker.snippet = element.title
                    marker.map = self.mapViewController
                }
            }
        }
        
        let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: locLat, longitude: locLon), radius: Double(self.radius.value))
        circ.fillColor = UIColor(red: 0, green: 0, blue: 0.35, alpha: 0.15)
        circ.strokeColor = UIColor.blueColor()
        circ.strokeWidth = 1
        circ.map = self.mapViewController

    }
    
    @IBAction func refresh(sender: AnyObject) {
        ARSLineProgress.show()
        let headers = ["Authorization": "Bearer " + token]
        let categoryData = selected
        let sortData = "По рейтингу"
        let categ = categoryData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let sort = sortData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let min = String(Int(rangeSlider1.lowerValue))
        let max = String(Int(rangeSlider1.upperValue))

        let rat = String(0)
        
        let resp = "\(url)/api/services/\(categ!)/\(sort!)/\(min)/\(max)/\(rat)/\(locLat)/\(locLon)/0/1000"
        
        Alamofire.request(.GET, resp,  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.mapResult.removeAll()
                    let json = JSON(data: response.data!)
                    for (_, subJson):(String, JSON) in json {
                        let resultData = DataResult(serID: subJson["serID"].stringValue, userID: subJson["userID"].stringValue, title: subJson["title"].stringValue, description: subJson["description"].stringValue, category: subJson["category"].stringValue, authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue, authorNickname: subJson["authorNickname"].stringValue, phone: subJson["phone"].stringValue, price: subJson["price"].stringValue, start: subJson["start"].stringValue, end: subJson["end"].stringValue, lat: subJson["lat"].stringValue, lon: subJson["lon"].stringValue, rating: subJson["rating"].stringValue,
                            speed: subJson["speed"].stringValue, cost: subJson["cost"].stringValue,
                            court: subJson["court"].stringValue, quality: subJson["quality"].stringValue,
                            countView: subJson["countView"].stringValue,
                            countReview: subJson["countReview"].stringValue, dist: subJson["dist"].stringValue)
                        self.mapResult += [resultData!]
                    }
                    
                    self.mapViewController.clear()
                    for (_, element) in self.mapResult.enumerate() {
                        if (element.lat != "" || element.lon != "") {
                            if (self.distans(locLat, lon: locLon, cLat: Double(element.lat)!, cLon: Double(element.lon)!) < Double(self.radius.value)) {
                                let marker = GMSMarker()
                                
                                marker.position = CLLocationCoordinate2D(latitude: Double(element.lat)!, longitude: Double(element.lon)!)
                                marker.userData = element
                                marker.snippet = element.title
                                marker.map = self.mapViewController
                            }
                        }
                    }
                    
                    let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: locLat, longitude: locLon) , radius: Double(self.radius.value))
                    circ.fillColor = UIColor(red: 0, green: 0, blue: 0.35, alpha: 0.15)
                    circ.strokeColor = UIColor.blueColor()
                    circ.strokeWidth = 1
                    circ.map = self.mapViewController
                    
                    ARSLineProgress.hide()
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
    }
    
    func AlertMessage(title: String, message: String)
    {
        ARSLineProgress.hide()
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
    
    func distans(lat: Double, lon: Double, cLat: Double, cLon: Double) -> Double
    {
        let radius =  6378.137
        let rad = 3.14 / 180
        let rLat = lat * rad
        let rLon = lon * rad
        let rCLat = cLat * rad
        let rCLon = cLon * rad
        let sinDLat = sin(self.delta(rLat, y: rCLat) / 2.0)
        let sinDLon = sin(self.delta(rLon, y: rCLon) / 2.0)
        let powLat = pow(sinDLat, 2)
        let powLon = pow(sinDLon, 2)
        let sqrtF = sqrt(powLat + cos(rCLat) * cos(rLat) * powLon)
        let deltaQ = 2 * asin(sqrtF)
        return radius * deltaQ * 1000
    }
    
    func delta(x: Double, y: Double) -> Double
    {
         return abs(abs(x) - abs(y))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first = true
        mapViewController.delegate = self
        mapViewController.myLocationEnabled = true
        mapViewController.settings.myLocationButton = true
        
        view.addSubview(rangeSlider1)
        rangeSlider1.addTarget(self, action: #selector(FilterViewController.rangeSliderValueChanged(_:)), forControlEvents: .ValueChanged)
        let headers = ["Authorization": "Bearer " + token]
        Alamofire.request(.GET, "\(url)/api/minmax",  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    self.rangeSlider1.maximumValue = Double(json["max"].stringValue)!
                    self.rangeSlider1.minimumValue = Double(json["min"].stringValue)!
                    self.rangeSlider1.lowerValue = self.rangeSlider1.minimumValue
                    self.rangeSlider1.upperValue = self.rangeSlider1.maximumValue
                    self.priceField.text = "От \(Int(self.rangeSlider1.lowerValue)) до \(Int(self.rangeSlider1.upperValue)) руб."
                    self.ratingLabel.text = "\(String(Int(self.radius.value))) м."
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
        
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        mapViewController.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: locLat, longitude: locLon), zoom: 12, bearing: 0, viewingAngle: 0)
        
        let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: locLat, longitude: locLon), radius: Double(self.radius.value))
        circ.fillColor = UIColor(red: 0, green: 0, blue: 0.35, alpha: 0.15)
        circ.strokeColor = UIColor.blueColor()
        circ.strokeWidth = 1
        circ.map = self.mapViewController
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider1.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 170, width: width, height: 31.0)
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        rangeSlider1.lowerValue = round(rangeSlider1.lowerValue / 100) * 100
        rangeSlider1.upperValue = round(rangeSlider1.upperValue / 100) * 100
        priceField.text = "От \(Int(rangeSlider1.lowerValue)) до \(Int(rangeSlider1.upperValue)) руб."
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = categories[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    

    func mapView(mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        if let infoView = MarkerInfoView.loadFromNibNamed("MarkerInfoView") as! MarkerInfoView!
        {
            let data = marker.userData as! DataResult
            infoView.nameLabel.text = data.title
            infoView.priceLabel.text = "Стоимость: " + (NSString(format: "%.0f", Double(data.price)!) as String) + " руб."
            //infoView.descriptionLabel.text = data.description
            
            return infoView
        } else {
            return nil
        }
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}
