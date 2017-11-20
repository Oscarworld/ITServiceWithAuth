//
//  DetailsViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 24.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var showContacts: UIButton!
    @IBOutlet weak var mapViewController: GMSMapView!
    @IBOutlet weak var speedRate: UILabel!
    @IBOutlet weak var courRate: UILabel!
    @IBOutlet weak var qualityRate: UILabel!
    @IBOutlet weak var costRate: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favorite: UIButton!
    

    @IBAction func addToFavorite(sender: AnyObject) {
        favorite.setImage(UIImage(named: "ic_favorite_red.png"), forState: UIControlState.Normal)
        favorite.userInteractionEnabled = false
    }
    @IBAction func showContacts(sender: AnyObject) {
        show = true
        self.performSegueWithIdentifier("DetailsToContacts", sender: self)
    }
    @IBAction func showReviews(sender: AnyObject) {
        let headers = ["Authorization": "Bearer " + token]
        let resp = "\(url)/api/reviews/\(result!.serID)"
        
        Alamofire.request(.GET, resp,  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    reviews.removeAll()
                    let json = JSON(data: response.data!)
                    for (_, subJson):(String, JSON) in json {
                        let resultData = DataReviews(reviewerID: subJson["reviewerID"].stringValue, description: subJson["description"].stringValue,
                            authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue,
                            dateTimeShow: subJson["dateTimeShow"].stringValue,
                            speed: subJson["speed"].stringValue, cost: subJson["cost"].stringValue,
                            court: subJson["court"].stringValue, quality: subJson["quality"].stringValue)
                        reviews += [resultData!]
                    }
                    self.performSegueWithIdentifier("DetailsToReviews", sender: self)
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
    }
    
    func AlertMessage(title: String, message: String)
    {
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
    
    let s1: String = result!.serID
    let s2: String = show ? "true" : "false"
    let s3: String = emailUser
    
    
    override func viewDidDisappear(animated: Bool) {
        let parameters = [
            "Service_id": s1,
            "Show_cont": s2,
            "User_name": s3
        ]
        let headers = ["Authorization": "Bearer " + token]
        
        Alamofire.request(.POST, url + "/api/histories", parameters: parameters, headers: headers)
        show = false
    }
    
    func createStars(label: UILabel!, rate: Double) {
        for index2 in 1...5 {
            if Double(index2) <= rate {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                self.scrollView.addSubview(bgImage!)
            } else if Double(index2) <= (rate + 0.5) {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star_half")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                self.scrollView.addSubview(bgImage!)
            } else {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star_border")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                self.scrollView.addSubview(bgImage!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showContacts.layer.cornerRadius = 5
        showContacts.layer.borderWidth = 1
        showContacts.layer.borderColor = UIColor( red: 66/255, green: 143/255, blue:244/255, alpha: 1.0 ).CGColor
        
        titleField.text = result?.title
        category.text = result?.category
        price.text = "Стоимость: " + (NSString(format: "%.0f", Double(result!.price)!) as String) + " руб."
        textField.text = result?.description
        textField.sizeToFit()
        
        mapViewController.myLocationEnabled = true
        mapViewController.settings.myLocationButton = true
        
        for index in 1...4 {
            switch index {
            case 1:
                let rate = Double((result?.speed)!)
                createStars(speedRate, rate: rate!)
                break
            case 2:
                let rate = Double((result?.cost)!)
                createStars(costRate, rate: rate!)
                break
            case 3:
                let rate = Double((result?.court)!)
                createStars(courRate, rate: rate!)
                break
            case 4:
                let rate = Double((result?.quality)!)
                createStars(qualityRate, rate: rate!)
                break
            default:
                break
            }
        }
        let lat = Double(result!.lat)!
        let lon = Double(result!.lon)!
        mapViewController.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: lon), zoom: 12, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.snippet = result?.title
        marker.map = mapViewController
     
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: lon)) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                self.location.text = lines.joinWithSeparator("\n")
                
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                self.location.text = lines.joinWithSeparator("\n")
                
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

