//
//  ValidationController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 18.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Foundation

func validation(tag: Int, str: String) -> Bool {
    switch tag {
    case 0:
        return isValidEmail(str)
    case 1:
        return isValidPassword(str)
    case 2:
        return isValidName(str)
    case 3:
        return isValidPhone(str)
    case 4:
        return isValidTitle(str)
    case 5:
        return isValidDescription(str)
    case 6:
        return isValidPrice(str)
    default:
        break
    }
    return false
}

func validBeginChange(sender: AnyObject) {
    let field = sender as! UITextField
    
    if (validation(field.tag, str: field.text!)) {
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1.4
        field.layer.borderColor = UIColor.init(red: 1/255, green: 184/255, blue: 154/255, alpha: 1.0).CGColor
    } else {
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1.4
        field.layer.borderColor = UIColor.init(red: 235/255, green: 91/255, blue: 82/255, alpha: 1.0).CGColor
    }
}

func validEnd(sender: AnyObject) {
    let field = sender as! UITextField
    
     field.layer.borderWidth = 0
}


func validBeginChangeConfirmed(sender: AnyObject, pasField: UITextField) {
    let field = sender as! UITextField
    
    if (validation(field.tag, str: field.text!) && field.text == pasField.text) {
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1.4
        field.layer.borderColor = UIColor.init(red: 1/255, green: 184/255, blue: 154/255, alpha: 1.0).CGColor
    } else {
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 1.4
        field.layer.borderColor = UIColor.init(red: 235/255, green: 91/255, blue: 82/255, alpha: 1.0).CGColor
    }
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

func isValidPassword(testStr:String) -> Bool {
    let passwordRegEx = "(?=^.{8,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluateWithObject(testStr)
}

func isValidName(testStr:String) -> Bool {
    let nameRegEx = "^[а-яА-ЯёЁa-zA-Z]+"
    let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
    return nameTest.evaluateWithObject(testStr)
}

func isValidPhone(testStr:String) -> Bool {
    let RegEx = "^((8|\\+7)[\\- ]?)?(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluateWithObject(testStr)
}

func isValidTitle(testStr:String) -> Bool {
    let RegEx = "[а-яА-ЯёЁa-zA-Z\\s\\S._%+-]{1,30}"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluateWithObject(testStr)
}

func isValidDescription(testStr:String) -> Bool {
    let RegEx = "[а-яА-ЯёЁa-zA-Z\\s\\S._%+-]{1,3000}"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluateWithObject(testStr)
}

func isValidPrice(testStr:String) -> Bool {
    let RegEx = "[1-9][0-9]*"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluateWithObject(testStr)
}