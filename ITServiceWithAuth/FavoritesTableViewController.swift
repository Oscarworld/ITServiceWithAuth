//
//  FavoritesTableViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 20.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FavoritesTableViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.userInteractionEnabled = false
        let headers = ["Authorization": "Bearer " + token]
        let fav = favorites[indexPath.row]

        Alamofire.request(.GET, "\(url)/services/\(fav.serID)",  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    result = DataResult(serID: json["serID"].stringValue, userID: json["userID"].stringValue, title: json["title"].stringValue, description: json["description"].stringValue, category: json["category"].stringValue, authorFirst: json["authorFirst"].stringValue, authorSecond: json["authorSecond"].stringValue, authorNickname: json["authorNickname"].stringValue, phone: json["phone"].stringValue, price: json["price"].stringValue, start: json["start"].stringValue, end: json["end"].stringValue, lat: json["lat"].stringValue, lon: json["lon"].stringValue, rating: json["rating"].stringValue,
                        speed: json["speed"].stringValue, cost: json["cost"].stringValue,
                        court: json["court"].stringValue, quality: json["quality"].stringValue,
                        countView: json["countView"].stringValue,
                        countReview: json["countReview"].stringValue, dist: json["dist"].stringValue)
                    tableView.userInteractionEnabled = true
                    self.performSegueWithIdentifier("FavoritesToDetails", sender: self)
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let fav = favorites[indexPath.row]
        cell.textLabel?.text = fav.title
        
        return cell
    }
    
    func AlertMessage(title: String, message: String)
    {
        tableView.userInteractionEnabled = true
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
}
