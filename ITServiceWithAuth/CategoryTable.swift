//
//  CategoryTableViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 23.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CategoryTable: UITableView {
    
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let headers = ["Authorization": "Bearer " + token]
        let selectedData = categories[indexPath.row]
        let str = selectedData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        Alamofire.request(.GET, url + "/api/services/" + str! + "/0",  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    //print("Suc{0}", response)
                    results.removeAll()
                    let json = JSON(data: response.data!)
                    for (_, subJson):(String, JSON) in json {
                        let resultData = DataResult(serID: subJson["serID"].stringValue, userID: subJson["userID"].stringValue, catID: subJson["catID"].stringValue, title: subJson["title"].stringValue, description: subJson["description"].stringValue, category: subJson["category"].stringValue, authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue, authorNickname: subJson["authorNickname"].stringValue, phone: subJson["phone"].stringValue, address: subJson["address"].stringValue, price: subJson["price"].stringValue, start: subJson["start"].stringValue, end: subJson["end"].stringValue, lon: subJson["lon"].stringValue, lat: subJson["lat"].stringValue, rating: subJson["rating"].stringValue, gender: subJson["gender"].stringValue)
                        results += [resultData!]
                    }
                    
                    self.performSegueWithIdentifier("MainToResult", sender: self)
                case .Failure: break
                    //self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let todo = categories[indexPath.row]
        cell.textLabel?.text = todo
        
        return cell
    }
}
