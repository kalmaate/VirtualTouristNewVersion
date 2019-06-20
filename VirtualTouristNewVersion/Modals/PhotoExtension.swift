//
//  PhotoExtension.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/13/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import Foundation
import CoreData
import MapKit


extension Photo {
    
    var image: UIImage? {
        guard let data = imageData else {
            return nil
        }
        return UIImage(data: data)
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
    func set(image: UIImage){
        self.imageData = image.pngData()
    }
    
    func get() -> UIImage? {
        return (imageData == nil) ? nil: UIImage(data: imageData!)
    }
    
    
    


}


