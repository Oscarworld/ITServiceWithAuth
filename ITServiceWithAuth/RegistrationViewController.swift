//
//  RegistrationViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 22.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ARSLineProgress

class RegistrationViewController: UIViewController {

    @IBOutlet weak var firstField: UITextField!
    @IBOutlet weak var lastField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    // Validation
    @IBAction func beginChange(sender: AnyObject) {
        validBeginChange(sender)
    }
    
    @IBAction func beginChangeConfirmed(sender: AnyObject) {
        validBeginChangeConfirmed(sender, pasField: passwordField)
    }
    
    @IBAction func endChange(sender: AnyObject) {
        validEnd(sender)
    }
    // -------------
    
    
    func initField(button: UITextField!)
    {
        button.borderStyle = UITextBorderStyle.RoundedRect;
    }
    
    func CheckFields() -> Bool
    {
        if (CheckField(firstField, message: "Введите имя")) { return true }
        if (CheckField(lastField, message: "Введите фамилию")) { return true }
        if (CheckField(emailField, message: "Введите email")) { return true }
        if (CheckField(phoneField, message: "Введите телефон")) { return true }
        if (CheckField(passwordField, message: "Введите пароль")) { return true }
        if (CheckField(confirmField, message: "Подтвердите пароль")) { return true }
        if (confirmField.text! != passwordField.text!) {
            self.AlertMessage("Ошибка", message: "Подтвердите пароль")
            return true
        }
        return false
    }
    
    func CheckField(field: UITextField, message: String) -> Bool
    {
        if (field.text!.isEmpty || !validation(field.tag, str: field.text!))
        {
            self.AlertMessage("Ошибка", message: message)
            return true
        }
        return false
    }
    
    func AlertMessage(title: String, message: String)
    {
        ARSLineProgress.hide()
        signupOutlet.userInteractionEnabled = true
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
    
    @IBAction func signUp(sender: AnyObject) {
        ARSLineProgress.show()
        signupOutlet.userInteractionEnabled = false
        if (CheckFields()) { return }
        emailUser = emailField.text!
        
        var parameters = [
            "Email": emailField.text!,
            "FirstName": firstField.text!,
            "LastName": lastField.text!,
            "PhoneNumber": phoneField.text!,
            "Employer": switchOutlet.on ? "true" : "false",
            "Password": passwordField.text!,
            "ConfirmPassword": confirmField.text!
        ]
        
        Alamofire.request(.POST, url + "/api/Account/Register", parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        parameters = [
                            "username": self.emailField.text!,
                            "password": self.passwordField.text!,
                            "grant_type": "password"
                        ]
                        
                        Alamofire.request(.POST, url + "/token", parameters: parameters)
                            .responseJSON { response in
                                switch response.result {
                                case .Success:
                                    let json = JSON(data: response.data!)
                                    token = json["access_token"].stringValue
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
                                                self.signupOutlet.userInteractionEnabled = true
                                                ARSLineProgress.hide()
                                                self.performSegueWithIdentifier("SingupToCateg", sender: self)
                                            case .Failure:
                                                self.AlertMessage("Ошибка", message: "Сервер недоступен")
                                            }
                                    }
                                case .Failure:
                                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                                }
                        }
                    case .Failure:
                        self.AlertMessage("Ошибка", message: "Пользватель с таким email уже существует")
                    }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initField(self.firstField)
        initField(self.lastField)
        initField(self.emailField)
        initField(self.phoneField)
        initField(self.passwordField)
        initField(self.confirmField)

        signupOutlet.layer.cornerRadius = 5
        signupOutlet.layer.borderWidth = 1
        signupOutlet.layer.borderColor = UIColor.whiteColor().CGColor
    }
}
