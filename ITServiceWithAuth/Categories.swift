//
//  Categories.swift
//  ITServiceWithAuth
//
//  Created by Admin on 23.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class Categories {
    // MARK: Properties
    
    var name: String = ""
    
    init?(name: String) {
        self.name = name
        
        if name.isEmpty {
            return nil
        }
    }
}