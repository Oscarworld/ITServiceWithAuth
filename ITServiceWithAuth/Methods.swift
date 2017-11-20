//
//  Methods.swift
//  ITServiceWithAuth
//
//  Created by Admin on 24.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps
import CoreLocation

var url = "http://itservicewithauth.azurewebsites.net"
var token = ""
var categories = [String]()
var results = [DataResult]()
var reviews = [DataReviews]()
var favorites = [DataFavorite]()
var review = DataReviews()
var result = DataResult()
var favorite = DataFavorite()
var selectedCategory = ""
var emailUser = ""
var employer = false
var locLat = 0.0
var locLon = 0.0
var labelAddress = ""
var boolLoc = false
var createPos: CLLocationCoordinate2D = CLLocationCoordinate2D()
var show = false
var currentCategory = ""
var currentSort = ""
var curMax = 0
var curMin = 0
var curRat = 0
var countOnPage = 10

func StringToJSON(str: String) -> JSON
{
    var newJson: JSON = JSON(":")
    do {
        let jsonString = str
        let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let jsonObject: AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions(rawValue: 0))
        newJson = JSON(jsonObject)
    } catch {
        print("Error StringToJSON")
    }
    return newJson
}