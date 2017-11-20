//
//  Favorites.swift
//  ITServiceWithAuth
//
//  Created by Admin on 20.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
class DataFavorite {
    var serID: String = ""
    var favID: String = ""
    var title: String = ""
    
    init?(serID: String, favID: String, title: String) {
        self.serID = serID
        self.favID = favID
        self.title = title
        
        
        if serID.isEmpty || favID.isEmpty {
            return nil
        }
    }
    
    init?()
    {
        return nil
    }

}
