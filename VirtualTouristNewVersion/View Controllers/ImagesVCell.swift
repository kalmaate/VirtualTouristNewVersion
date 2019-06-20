//
//  ImagesVCell.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/9/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import UIKit

class ImagesVCell: UICollectionViewCell {
    
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    var photo: Photo? {
        willSet {
            if photo != nil {
                return
            }
            
            guard let ph = newValue else { return }
            guard let url = ph.imageURL else { return }
            
            if let image = ph.image  {
                imagesView.image = image
                return
            }
            
            imageActivityIndicator.startAnimating()
            guard let data = try? Data(contentsOf: url) else { return }
            imageActivityIndicator.stopAnimating()
            
            imagesView.image = UIImage(data: data)
            
            ph.imageData = data
            try? ph.managedObjectContext?.save()
            
        }
    }

}
