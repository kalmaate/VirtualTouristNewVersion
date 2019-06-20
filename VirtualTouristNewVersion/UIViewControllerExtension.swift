//
//  UIViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/19/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler:   nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
