//
//  CategoryTableViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 23.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import LiquidFloatingActionButton
import Alamofire
import ARSLineProgress
import CoreLocation

class CategTableViewController: UITableViewController {
    
    var cells = [LiquidFloatingCell]()
    var floatingActionButton: LiquidFloatingActionButton!
    
    var newView: UIView!
    
    @IBOutlet weak var onMapOutlet: UIBarButtonItem!
    @IBAction func ToMap(sender: AnyObject) {
        self.performSegueWithIdentifier("CategToMap", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        newView = UIView(frame: CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 0, height: 0))
        self.view.addSubview(newView)
        self.tableView.reloadData()
        createFloatingButton()
    }
    
    private func createFloatingButton()
    {
        cells.append(createButtonCell("ic_place_white"))
        cells.append(createButtonCell("ic_note_add_white"))
        cells.append(createButtonCell("ic_favorite_white.png"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 112 - 16, width: 56, height: 56)
        let floatingButton = createButton(floatingFrame, style: .Up)
        self.view.addSubview(floatingButton)
        self.floatingActionButton = floatingButton
    }
    
    private func createButtonCell(iconName: String) -> LiquidFloatingCell
    {
        return LiquidFloatingCell(icon: UIImage(named: iconName)!)
    }
    
    private func createButton(frame: CGRect, style: LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton
    {
        let floatingActionButton = LiquidFloatingActionButton(frame: frame)
        
        floatingActionButton.animateStyle = style
        floatingActionButton.dataSource = self
        floatingActionButton.delegate = self
        
        return floatingActionButton
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    @IBAction func createService(sender: AnyObject) {
        self.performSegueWithIdentifier("CategToCreate", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.userInteractionEnabled = false
        onMapOutlet.enabled = false
        let headers = ["Authorization": "Bearer " + token]
        let selectedData = categories[indexPath.row]
        let categ = selectedData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let sortData = "По дате публикации"
        currentSort = sortData
        let sort = sortData.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        currentCategory = selectedData
        let rat = 0.0
        
        var min = 0
        var max = 0
        Alamofire.request(.GET, "\(url)/api/minmax",  headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)
                    min = Int(Double(json["min"].stringValue)!)
                    max = Int(Double(json["max"].stringValue)!)
                    
                    curMin = min
                    curMax = max
                    
                    let resp = "\(url)/api/services/\(categ!)/\(sort!)/\(min)/\(max)/\(rat)/\(locLat)/\(locLon)/0/\(countOnPage)"
        
                    Alamofire.request(.GET, resp,  headers: headers)
                        .responseJSON { response in
                            ARSLineProgress.show()
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
                                self.onMapOutlet.enabled = true
                                tableView.userInteractionEnabled = true
                                ARSLineProgress.hide()
                                self.performSegueWithIdentifier("CategToResult", sender: self)
                            case .Failure:
                                self.AlertMessage("Ошибка", message: "Сервер недоступен")
                            }
                     }
                case .Failure:
                    self.AlertMessage("Ошибка", message: "Сервер недоступен")
                }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ARSLineProgress.hide()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CategViewCell
        
        let cat = categories[indexPath.row]
        cell.nameCategory.sizeToFit()
        cell.nameCategory.text = cat
        
        return cell
    }
    
    func AlertMessage(title: String, message: String)
    {
        ARSLineProgress.showFail()
        ARSLineProgress.hide()
        onMapOutlet.enabled = true
        tableView.userInteractionEnabled = true
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self!.presentViewController(alertController, animated: true, completion: nil)
            })
    }
}

extension CategTableViewController: LiquidFloatingActionButtonDataSource
{
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int
    {
        return cells.count
    }
    func cellForIndex(index: Int) -> LiquidFloatingCell
    {
        return cells[index]
    }
    
}


extension CategTableViewController: LiquidFloatingActionButtonDelegate
{
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int)
    {
        switch index {
        case 0:
            self.performSegueWithIdentifier("CategToMap", sender: self)
            break
        case 1:
            self.performSegueWithIdentifier("CategToCreate", sender: self)
            break
        case 2:
            tableView.userInteractionEnabled = false
            
            let headers = ["Authorization": "Bearer " + token]
            let resp = "\(url)/api/favorites"
            
            Alamofire.request(.GET, resp, headers: headers)
                .responseJSON { response in
                    ARSLineProgress.show()
                    switch response.result {
                    case .Success:
                        favorites.removeAll()
                        let json = JSON(data: response.data!)
                        for (_, subJson):(String, JSON) in json {
                            let resultData = DataFavorite(serID: subJson["serID"].stringValue, favID: subJson["favID"].stringValue, title: subJson["title"].stringValue)
                            favorites += [resultData!]
                        }
                        self.onMapOutlet.enabled = true
                        self.tableView.userInteractionEnabled = true
                        ARSLineProgress.hide()
                        self.performSegueWithIdentifier("CategToFavorite", sender: self)
                    case .Failure:
                        self.AlertMessage("Ошибка", message: "Сервер недоступен")
                    }
            }
            break
        default:
            break
        }
    }
    
}







