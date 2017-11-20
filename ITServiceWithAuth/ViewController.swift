//
//  ViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ARSLineProgress
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // ----- Outlet -----
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registrationOutlet: UIButton!
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    var locationManager: CLLocationManager!
    
    // ----- Action -----
    //!---- Зарегистрироваться ----
    @IBAction func registrationBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("SinginToSingup", sender: self)
    }
    
    // Validation
    @IBAction func beginChangeEmail(sender: AnyObject) {
        validBeginChange(sender)
    }
    
    @IBAction func endChangeEmail(sender: AnyObject) {
        validEnd(sender)
    }
    // -------------
    
    //!---- Войти ----
    @IBAction func signupBtn(sender: AnyObject) {
        token = ""
        if (emailField.text!.isEmpty || !validation(emailField.tag, str: emailField.text!))
        {
            self.AlertMessage("Ошибка", message: "Введите логин")
            return
        }
        if (passwordField.text!.isEmpty || !validation(passwordField.tag, str: passwordField.text!))
        {
            self.AlertMessage("Ошибка", message: "Введите пароль")
            return
        }
        
        registrationOutlet.userInteractionEnabled = false
        signupOutlet.userInteractionEnabled = false
        ARSLineProgress.show()
        
        //self.progress.startAnimating()
        emailUser = emailField.text!
        let parameters = [
            "username": emailField.text!,
            "password": passwordField.text!,
            "grant_type": "password"
        ]

        Alamofire.request(.POST, url + "/token", parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    token = json["access_token"].stringValue
                    if (!token.isEmpty) {
                        let headers = ["Authorization": "Bearer " + token]
                        
                        Alamofire.request(.GET, url + "/api/categories",  headers: headers)
                            .responseJSON { response in
                                switch response.result {
                                case .Success:
                                    categories.removeAll()
                                    let json = JSON(data: response.data!)
                                    categories += ["Все категории"]
                                    for (_, subJson):(String, JSON) in json {
                                        categories += [subJson.stringValue]
                                    }
                                    ARSLineProgress.showSuccess()
                                    ARSLineProgress.hide()
                                    self.registrationOutlet.userInteractionEnabled = true
                                    self.signupOutlet.userInteractionEnabled = true
                                    //self.progress.stopAnimating()
                                    self.performSegueWithIdentifier("SinginToCateg", sender: self)
                                case .Failure:
                                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                                }
                        }
                    }
                    else {
                        self.AlertMessage("Ошибка", message: "Неверно указан логин и/или пароль")
                    }
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")

                }
        }
        
    }
    
    func AlertMessage(title: String, message: String)
    {
        //self.progress.stopAnimating()
        ARSLineProgress.showFail()
        ARSLineProgress.hide()
        registrationOutlet.userInteractionEnabled = true
        signupOutlet.userInteractionEnabled = true
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.emailField.borderStyle = UITextBorderStyle.RoundedRect;
        self.passwordField.borderStyle = UITextBorderStyle.RoundedRect;
        registrationOutlet.layer.cornerRadius = 5
        registrationOutlet.layer.borderWidth = 1
        registrationOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        signupOutlet.layer.cornerRadius = 5
        signupOutlet.layer.borderWidth = 1
        signupOutlet.layer.borderColor = UIColor.whiteColor().CGColor
        
        if (locationManager == nil) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if (locationManager.location?.coordinate != nil) {
                locLat = Double((locationManager.location?.coordinate.latitude)!)
                locLon = Double((locationManager.location?.coordinate.longitude)!)
            }
        }
    }
}

