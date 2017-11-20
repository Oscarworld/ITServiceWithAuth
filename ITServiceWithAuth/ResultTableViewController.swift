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
import CoreLocation

class ResultTableViewController: UITableViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    var loadMoreStatus = false
    var page = 0
    var first = false
    var end = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl!.addTarget(self, action: #selector(ResultTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        first = true
    }
    
    func refresh(sender:AnyObject) {
        let headers = ["Authorization": "Bearer " + token]
        let selectedData = currentCategory
        let categ = selectedData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let sortData = currentSort
        let sort = sortData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let rat = curRat
        
        let min = curMin
        let max = curMax
                    
        let resp = "\(url)/api/services/\(categ!)/\(sort!)/\(min)/\(max)/\(rat)/\(locLat)/\(locLon)/0/\((page + 1) * countOnPage)"
        
        Alamofire.request(.GET, resp,  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    results.removeAll()
                    let json = JSON(data: response.data!)
                    for (_, subJson):(String, JSON) in json {
                        let resultData = DataResult(serID: subJson["serID"].stringValue, userID: subJson["userID"].stringValue, title: subJson["title"].stringValue, description: subJson["description"].stringValue, category: subJson["category"].stringValue, authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue, authorNickname: subJson["authorNickname"].stringValue, phone: subJson["phone"].stringValue, price: subJson["price"].stringValue, start: subJson["start"].stringValue, end: subJson["end"].stringValue, lat: subJson["lat"].stringValue, lon: subJson["lon"].stringValue, rating: subJson["rating"].stringValue,
                            speed: subJson["speed"].stringValue, cost: subJson["cost"].stringValue,
                            court: subJson["court"].stringValue, quality: subJson["quality"].stringValue,
                            countView: subJson["countView"].stringValue,
                            countReview: subJson["countReview"].stringValue, dist: subJson["dist"].stringValue)
                        
                            results += [resultData!]
                    }
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                case .Failure:
                    break
                }
        }
    }
    
    func loadMore() {
        if ( !loadMoreStatus ) {
            loadMoreStatus = true
            
            let headers = ["Authorization": "Bearer " + token]
            let selectedData = currentCategory
            let categ = selectedData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            let sortData = currentSort
            let sort = sortData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            
            let rat = curRat
            
            let min = curMin
            let max = curMax
            
            let resp = "\(url)/api/services/\(categ!)/\(sort!)/\(min)/\(max)/\(rat)/\(locLat)/\(locLon)/\(page + 1)/\(countOnPage)"
            
            Alamofire.request(.GET, resp,  headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        let json = JSON(data: response.data!)
                        for (_, subJson):(String, JSON) in json {
                            let resultData = DataResult(serID: subJson["serID"].stringValue, userID: subJson["userID"].stringValue, title: subJson["title"].stringValue, description: subJson["description"].stringValue, category: subJson["category"].stringValue, authorFirst: subJson["authorFirst"].stringValue, authorSecond: subJson["authorSecond"].stringValue, authorNickname: subJson["authorNickname"].stringValue, phone: subJson["phone"].stringValue, price: subJson["price"].stringValue, start: subJson["start"].stringValue, end: subJson["end"].stringValue, lat: subJson["lat"].stringValue, lon: subJson["lon"].stringValue, rating: subJson["rating"].stringValue,
                                speed: subJson["speed"].stringValue, cost: subJson["cost"].stringValue,
                                court: subJson["court"].stringValue, quality: subJson["quality"].stringValue,
                                countView: subJson["countView"].stringValue,
                                countReview: subJson["countReview"].stringValue, dist: subJson["dist"].stringValue)
                            var existRes = false
                            for (res):(DataResult) in results {
                                if res.serID == resultData?.serID {
                                    existRes = true
                                }
                            }
                            if !existRes {
                                results += [resultData!]
                            }
                        }
                        if json.count != 0 {
                            self.page += 1
                        } else {
                            self.end = true
                        }
                        self.loadMoreStatus = false
                        self.tableView.reloadData()
                    case .Failure:
                        break
                    }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
         tableView.reloadData()
    }
    
    @IBAction func filter(sender: AnyObject) {
        self.performSegueWithIdentifier("ResultToFilter", sender: self)
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        result = results[indexPath.row]
        self.performSegueWithIdentifier("ResultToDetails", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ResultTableViewCell
        
        let result = results[indexPath.row]
        cell.title.text = result.title
        cell.price.text = "Стоимость: " + (NSString(format: "%.0f", Double(result.price)!) as String) + " руб."
        cell.address.text = result.description
        
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "ru_RU")
        inFormatter.dateFormat = "M/d/yyyy HH:mm:ss a" //"12/8/2014 12:00:00 AM"
        
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "ru_RU")
        outFormatter.dateFormat = "dd MMMM HH:mm"
        
        let date = inFormatter.dateFromString(result.start)!
        cell.date.text = "Дата публикации: " + outFormatter.stringFromDate(date)
 
        cell.rating.text = (NSString(format: "%.2f", Double(result.rating)!) as String)
        
        cell.countView.text = (NSString(format: "%.0f", Double(result.countView)!) as String)
        cell.countReview.text = (NSString(format: "%.0f", Double(result.countReview)!) as String)
        
        cell.dist.text = (NSString(format: "%.0f", Double(result.dist)!) as String) + "м."
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row + 1) >= results.count {
            if !end {
                loadMore()
            }
        }
    }
}
