//
//  CreateReviewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 19.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire

class CreateReviewController: UIViewController {
    
    var cost = 3
    var speed = 3
    var quality = 3
    var court = 3
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var sendReviewBut: UIBarButtonItem!
    
    @IBAction func createService(sender: AnyObject) {
        if (textField.text!.isEmpty || !validation(textField.tag, str: textField.text!)) {
            self.AlertMessage("Ошибка", message: "Введите описание")
            return
        }
        
        let parameters = [
            "Description": textField.text!,
            "Cost": String(cost),
            "Speed": String(speed),
            "Quality": String(quality),
            "Court": String(court),
            "SerID": String(result!.serID),
            "User_name": emailUser
        ]
        let headers = ["Authorization": "Bearer " + token]
        
        Alamofire.request(.POST, url + "/api/reviews", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.sendReviewBut.enabled = false
                    self.AlertMessage("Выполнено", message: "Отзыв отправлен")
                    self.textField.text! = ""
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

    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    
    @IBOutlet weak var two_2: UIButton!
    @IBOutlet weak var three_2: UIButton!
    @IBOutlet weak var four_2: UIButton!
    @IBOutlet weak var five_2: UIButton!
    
    @IBOutlet weak var two_3: UIButton!
    @IBOutlet weak var three_3: UIButton!
    @IBOutlet weak var four_3: UIButton!
    @IBOutlet weak var five_3: UIButton!
    
    @IBOutlet weak var two_4: UIButton!
    @IBOutlet weak var three_4: UIButton!
    @IBOutlet weak var four_4: UIButton!
    @IBOutlet weak var five_4: UIButton!
    
    
    func changeRate(sender_2: AnyObject, sender_3: AnyObject, sender_4: AnyObject, sender_5: AnyObject,rate: Int) {
        switch rate {
        case 1:
            sender_2.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_3.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_4.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_5.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            break
        case 2:
            sender_2.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_3.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_4.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_5.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            break
        case 3:
            sender_2.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_3.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_4.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            sender_5.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            break
        case 4:
            sender_2.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_3.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_4.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_5.setImage(UIImage(named: "ic_star_border.png"), forState: UIControlState.Normal)
            break
        case 5:
            sender_2.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_3.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_4.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            sender_5.setImage(UIImage(named: "ic_star.png"), forState: UIControlState.Normal)
            break
        default:
            break
        }
    }
    
    func preChange(sender: AnyObject, value: Int) {
        switch sender.tag {
        case 0:
            cost = value
            changeRate(two, sender_3: three, sender_4: four, sender_5: five, rate: value)
            break
        case 1:
            speed = value
            changeRate(two_2, sender_3: three_2, sender_4: four_2, sender_5: five_2, rate: value)
            break
        case 2:
            quality = value
            changeRate(two_3, sender_3: three_3, sender_4: four_3, sender_5: five_3, rate: value)
            break
        case 3:
            court = value
            changeRate(two_4, sender_3: three_4, sender_4: four_4, sender_5: five_4, rate: value)
            break
        default:
            break
        }
    }
    
    @IBAction func One(sender: AnyObject) {
        preChange(sender, value: 1)
    }
    @IBAction func Two(sender: AnyObject) {
        preChange(sender, value: 2)
    }
    @IBAction func Three(sender: AnyObject) {
        preChange(sender, value: 3)
    }
    @IBAction func Four(sender: AnyObject) {
        preChange(sender, value: 4)
    }
    @IBAction func Five(sender: AnyObject) {
        preChange(sender, value: 5)
    }
}
