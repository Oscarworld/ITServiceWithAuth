//
//  Result.swift
//  ITServiceWithAuth
//
//  Created by Admin on 24.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class DataResult {
    // MARK: Properties
    
    var serID: String = ""
    var userID: String = ""
    var title: String = ""
    var description: String = ""
    var category: String = ""
    var authorFirst: String = ""
    var authorSecond: String = ""
    var authorNickname: String = ""
    var phone: String = ""
    var price: String = ""
    var start: String = ""
    var end: String = ""
    var lat: String = ""
    var lon: String = ""
    var rating: String = ""
    var speed: String = ""
    var cost: String = ""
    var court: String = ""
    var quality: String = ""
    var countView: String = ""
    var countReview: String = ""
    var dist: String = ""

    
    init?(serID: String, userID: String,
          title: String, description: String, category: String, authorFirst: String, authorSecond: String, authorNickname: String, phone: String,
          price: String, start: String, end: String, lat: String, lon: String, rating: String,
          speed: String, cost: String, court: String, quality: String,
          countView: String, countReview: String, dist: String) {
        self.serID = serID
        self.userID = userID
        self.title = title
        self.description = description
        self.category = category
        self.authorFirst = authorFirst
        self.authorSecond = authorSecond
        self.authorNickname = authorNickname
        self.phone = phone
        self.price = price
        self.start = start
        self.end = end
        self.lat = lat
        self.lon = lon
        self.rating = rating
        self.speed = speed
        self.cost = cost
        self.court = court
        self.quality = quality
        self.countView = countView
        self.countReview = countReview
        self.dist = dist

        
        if serID.isEmpty || userID.isEmpty {
            return nil
        }
    }
    
    init?()
    {
        return nil
    }
}