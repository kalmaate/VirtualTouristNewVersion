//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/13/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import Foundation
import MapKit


class FlickerAPI{
    
    static func bboxString(for coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let searchBBoxHalfLength = 0.5
        
        let minimumLon = max(longitude - searchBBoxHalfLength, -180)
        let minimumLat = max(latitude - searchBBoxHalfLength, -90)
        let maximumLon = min(longitude + searchBBoxHalfLength, 180)
        let maximumLat = min(latitude + searchBBoxHalfLength, 90)
        
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
    
    static func getPhotos(with coordinate: CLLocationCoordinate2D, page: Int, completion: @escaping ([URL]?, String? ) -> ()) {

        let parameters = [
            FlickrParameterKeys.Method           : FlickrParameterValues.SearchMethod
            , FlickrParameterKeys.APIKey         : FlickrParameterValues.APIKey
            , FlickrParameterKeys.Format         : FlickrParameterValues.ResponseFormat
            , FlickrParameterKeys.Extras         : FlickrParameterValues.MediumURL
            , FlickrParameterKeys.NoJSONCallback : FlickrParameterValues.DisableJSONCallback
            , FlickrParameterKeys.SafeSearch     : FlickrParameterValues.UseSafeSearch
            , FlickrParameterKeys.BoundingBox    : FlickerAPI.bboxString(for: coordinate)
            , FlickrParameterKeys.PhotosPerPage  : "\(FlickrParameterValues.PhotosPerPage)"
            , FlickrParameterKeys.Page           : page
        ] as [String: Any]
        
    
    
        URLSession.shared.dataTask(with: getURL(parameters)) { data, response, error in
             if error != nil {
                 completion(nil, error?.localizedDescription)
                return
               }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion(nil, statusCodeError.localizedDescription)
                return
            }
            
            guard (statusCode >= 200  && statusCode <= 299) else {
                completion(nil, "The status code is not 2xx, but it is \(statusCode)")
                return
            }
            
            guard let data = data else {
                completion(nil, "Data is nil!")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            completion(nil, "JSON Could not be parsed")
            return
           }
            
            guard let stat = result?["stat"] as? String, stat == "ok" else {
                completion(nil, "Flicer did give an error. See the error: \(result!)")
                return
            }
            
            guard let photosDictionary = result?["photos"] as? [String: Any] else {
                completion(nil, "Cannot find key 'photos' in \(result!)")
                return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String: Any]] else {
                completion(nil, "cannot find key 'photo' in \(photosDictionary)")
                return
            }
            
            let photosURLs = photosArray.compactMap { photoDictionary -> URL? in
                guard let url = photoDictionary["url_m"] as? String else { return nil }
                return URL(string: url)
            }
            
            completion(photosURLs, nil)
            
            

        }.resume()
    

    }
    
    
    static func getURL(_ parameters: [String: Any], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Flickr.APIScheme
        components.host = Flickr.APIHost
        components.path = Flickr.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    

}



