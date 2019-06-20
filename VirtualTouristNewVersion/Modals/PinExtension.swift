//
//  PinExtension.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/13/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import Foundation
import MapKit


extension Pin {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
        
    }
    
    var pinCoordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func correspond(to coordinate: CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
    
    
    
}
