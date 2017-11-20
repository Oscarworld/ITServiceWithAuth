//
//  Result.swift
//  ITServiceWithAuth
//
//  Created by Admin on 24.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class DataReviews {
    // MARK: Properties
    
    var reviewerID: String = ""
    var description: String = ""
    var authorFirst: String = ""
    var authorSecond: String = ""
    var dateTimeShow: String = ""
    var speed: String = ""
    var cost: String = ""
    var court: String = ""
    var quality: String = ""
    
    
    init?(reviewerID: String, description: String, authorFirst: String, authorSecond: String,
          dateTimeShow: String,
          speed: String, cost: String, court: String, quality: String) {
        self.reviewerID = reviewerID
        self.description = description
        self.authorFirst = authorFirst
        self.authorSecond = authorSecond
        self.dateTimeShow = dateTimeShow
        self.speed = speed
        self.cost = cost
        self.court = court
        self.quality = quality
    }
    
    init?()
    {
        return nil
    }
}