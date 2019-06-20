//
//  DataController.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/19/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    let persistanceContainer = NSPersistentContainer(name: "VirtualTourist")
    
    var viewContext: NSManagedObjectContext{
        return persistanceContainer.viewContext
    }
    
    func load() {
        persistanceContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
