//
//  AppDelegate.swift
//  ITServiceWithAuth
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let googleMapsApiKey = "AIzaSyAQVcISDdB7ctgRjWXrOd4yeeXSdkgaS00"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        GMSServices.provideAPIKey(googleMapsApiKey)
        return true
    }
}

