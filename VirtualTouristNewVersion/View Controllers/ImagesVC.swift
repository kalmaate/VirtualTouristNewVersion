//
//  ImagesVC.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/9/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import UIKit
import  MapKit
import CoreData

class ImagesVC: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var InfoMessage: UILabel!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    var page = 0
    var isDeletingAll = false
    var isTherePhotos: Bool {
        if (fetchedResultsController.fetchedObjects?.count ?? 0) > 0 {
            return true
        }
        return false
    }
    
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.pinCoordinate
        self.InfoMessage.isHidden = true
        
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        // for the map to be zoomed in
       // let coordinate = pin.pinCoordinate
      //  let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 0.25, longitudinalMeters: 0.25)
       // mapView.setRegion(region, animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if isTherePhotos {
            collectionView.reloadData()
            } else {
                getFlickrPhotos()
            }
        }catch {
            fatalError("the fetched could not be performed \(error.localizedDescription)")
        }
    }

    
    func getFlickrPhotos(){
        bottomActivityIndicator.startAnimating()

        FlickerAPI.getPhotos(with: pin.pinCoordinate, page: page) { (urls, errorMessage) in

            /* Add results to photoData and reload flickrCollectionView */
            DispatchQueue.main.async {
                self.bottomActivityIndicator.stopAnimating()
                
                guard errorMessage == nil else {
                    self.alert(title: "Error ", message: errorMessage)
                    return
                }
                
                guard let urls = urls, urls.count > 0 else {
                   self.InfoMessage.isHidden = false
                    return
                }
                self.InfoMessage.isHidden = true
                
                for url in urls{
                    let photo = Photo(context: self.context)
                    photo.imageURL = url
                    photo.pin = self.pin
                    try? self.context.save()
                }
            }
        }
        page += 1
    }

    func removePhotos() {
        isDeletingAll = true
        for photo in fetchedResultsController.fetchedObjects ?? [] {
            context.delete(photo)
            try? context.save()
        }
        isDeletingAll = false
    }
    
    @IBAction func newCollectionButton(_ sender: Any) {
        if isTherePhotos {
            removePhotos()
        }
        
        getFlickrPhotos()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ImagesVCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.photo = photo
        cell.backgroundColor = .red 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        
        let alert = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (_) in
            self.shareImage(image: photo.image)
        }))
        
        alert.addAction(UIAlertAction(title: "delete", style: .destructive, handler: { (_) in
            self.context.delete(photo)
            try? self.context.save()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
       
    }
    
    func shareImage(image: UIImage?) {
        guard let image = image else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, completed, items, error) in
            if completed {
                self.alert(title: "Success", message: "Image saved successfully")
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }
}
