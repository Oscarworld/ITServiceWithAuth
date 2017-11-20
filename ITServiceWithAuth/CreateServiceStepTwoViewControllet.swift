//
//  CreateServiceStepTwoViewControllet.swift
//  ITServiceWithAuth
//
//  Created by Admin on 26.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class CreateServiceStepTwoViewControllet: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var myLocationLabel: UIButton!
    @IBOutlet weak var onMapLabel: UIButton!
    
    // Validation
    @IBAction func beginChangeEmail(sender: AnyObject) {
        validBeginChange(sender)
    }
    
    @IBAction func endChangeEmail(sender: AnyObject) {
        validEnd(sender)
    }
    // -------------
    
    
    @IBAction func createService(sender: AnyObject) {
        if (titleField.text!.isEmpty || !validation(titleField.tag, str: titleField.text!)) {
            self.AlertMessage("Ошибка", message: "Введите название")
            return
        }
        if (price.text!.isEmpty || !validation(price.tag, str: price.text!)) {
            self.AlertMessage("Ошибка", message: "Введите стоимость")
            return
        }
        if (textField.text!.isEmpty || !validation(textField.tag, str: textField.text!)) {
            self.AlertMessage("Ошибка", message: "Введите описание")
            return
        }
        
        let parameters = [
            "Title": titleField.text!,
            "Description": textField.text!,
            "Price": price.text!,
            "Lat": String(createPos.latitude),
            "Lon": String(createPos.longitude),
            "Category_name": selectedCategory,
            "User_name": emailUser
        ]
        let headers = ["Authorization": "Bearer " + token]
        
        Alamofire.request(.POST, url + "/api/services", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.AlertMessage("Выполнено", message: "Услуга успешно создана")
                    self.titleField.text! = ""
                    self.textField.text! = ""
                    self.price.text! = ""
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Невозможно создать услугу")
                }
        }
    }
    
    @IBAction func myLocation(sender: AnyObject) {
        boolLoc = false
        myLocationLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        onMapLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
        currentPos(CLLocation(latitude: locLat, longitude: locLon))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (boolLoc)
        {
            myLocationLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
            onMapLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            addressLabel.text = labelAddress
        }
        else
        {
            myLocationLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            onMapLabel.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
            createPos = CLLocationCoordinate2D(latitude: locLat, longitude: locLon)
            currentPos(CLLocation(latitude: locLat, longitude: locLon))
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
    
    func currentPos(loc: CLLocation)
    {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(loc.coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                self.addressLabel.text = lines.joinWithSeparator("\n")
            }
        }
    }
}

