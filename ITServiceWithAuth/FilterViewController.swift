//
//  FilterViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 25.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ARSLineProgress
import GoogleMaps
import CoreLocation

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var categoriesPicker: UIPickerView!
    
    @IBOutlet weak var sortForDate: SSRadioButton!
    @IBOutlet weak var sotfForActual: SSRadioButton!
    @IBOutlet weak var sorfForPopul: SSRadioButton!
    @IBOutlet weak var sortForRait: SSRadioButton!
    @IBOutlet weak var sortForRange: SSRadioButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var showRait: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var locationManager: CLLocationManager!
    var oldSelected = SSRadioButton()
    var selected = "Все категории"
    let rangeSlider1 = RangeSlider(frame: CGRectZero)
    
    
    @IBAction func changeRait(sender: AnyObject) {
        slider.value = round(slider.value * 10) / 10
        showRait.text = String(slider.value)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectButton(sender: AnyObject) {
        oldSelected.selected = false
        (sender as! SSRadioButton).selected = true
        oldSelected = (sender as! SSRadioButton)
    }
    
    @IBAction func applyFilter(sender: AnyObject) {
        ARSLineProgress.show()
        let headers = ["Authorization": "Bearer " + token]
        let categoryData = selected
        let sortData = (oldSelected.titleLabel?.text)! as String
        currentSort = sortData	
        let categ = categoryData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let sort = sortData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let min = Int(rangeSlider1.lowerValue)
        let max = Int(rangeSlider1.upperValue)
        var lat = 0.0
        var lon = 0.0
        if locationManager.location != nil {
            lat = Double((locationManager.location?.coordinate.latitude)!)
            lon = Double((locationManager.location?.coordinate.longitude)!)
        }

        let rat = Int(slider.value)
        
        curRat = rat
        
        curMin = min
        curMax = max
        
        let resp = "\(url)/api/services/\(categ!)/\(sort!)/\(min)/\(max)/\(rat)/\(lat)/\(lon)/0/30"
         
        Alamofire.request(.GET, resp,  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    results.removeAll()
                    let json = JSON(data: response.data!)
                    for (_, subJson):(String, JSON) in json {
                        let resultData = DataResult(serID: subJson["serID"].stringValue, userID: subJson["userID"].stringValue, title: subJson["title"].stringValue, description: subJson["description"].stringValue, category: subJson["category"].stringValue, authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue, authorNickname: subJson["authorNickname"].stringValue, phone: subJson["phone"].stringValue, price: subJson["price"].stringValue, start: subJson["start"].stringValue, end: subJson["end"].stringValue, lat: subJson["lat"].stringValue, lon: subJson["lon"].stringValue, rating: subJson["rating"].stringValue,
                            speed: subJson["speed"].stringValue, cost: subJson["cost"].stringValue,
                            court: subJson["court"].stringValue, quality: subJson["quality"].stringValue,countView: subJson["countView"].stringValue,
                            countReview: subJson["countReview"].stringValue, dist: subJson["dist"].stringValue)
                        results += [resultData!]
                    }
                    ARSLineProgress.hide()
                    self.dismissViewControllerAnimated(true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.price.text = "От \(Int(self.rangeSlider1.lowerValue)) до \(Int(self.rangeSlider1.upperValue)) руб."
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
        
        categoriesPicker.delegate = self
        categoriesPicker.dataSource = self
        sortForDate.selected = true
        oldSelected = sortForDate
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider1.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 240, width: width, height: 31.0)
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        rangeSlider1.lowerValue = round(rangeSlider1.lowerValue / 100) * 100
        rangeSlider1.upperValue = round(rangeSlider1.upperValue / 100) * 100
        price.text = "От \(Int(rangeSlider1.lowerValue)) до \(Int(rangeSlider1.upperValue)) руб."
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
}
