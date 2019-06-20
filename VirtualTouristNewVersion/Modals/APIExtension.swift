//
//  APIExtension.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/13/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import Foundation

extension FlickerAPI {
    
    // MARK: - Flickr
    
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
      //  static let SearchBBoxHalfWidth = 0.2
      //  static let SearchBBoxHalfHeight = 0.2
      //  static let SearchLatRange = (-90.0, 90.0)
      //  static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: - Flickr Parameter Keys
    
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
        static let PhotosPerPage = "per_page"
        static let Accuracy = "accuracy"
        static let Page = "page"
    }
    
    // MARK: - Flickr Parameter Values
    
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "2d0b7093b997434fb69daab657ec6f01"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1" /* 1 means safe content */
        static let PhotosPerPage = 5

    }
}

