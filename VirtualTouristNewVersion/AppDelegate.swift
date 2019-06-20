//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/9/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DataController.shared.load()
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        try? DataController.shared.viewContext.save()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        try? DataController.shared.viewContext.save()
    }
}

