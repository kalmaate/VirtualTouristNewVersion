//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Kameela Almaateeq on 6/9/19.
//  Copyright © 2019 Kameela. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            updateMapView()
        }catch {
            fatalError("the fetched could not be performed \(error.localizedDescription)")
        }
    }
    
    func updateMapView() {
        guard let pins = fetchedResultsController.fetchedObjects else { return }
        
        for pin in pins {
            if map.annotations.contains(where: { pin.correspond(to: $0.coordinate)} ) { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.pinCoordinate
            map.addAnnotation(annotation)
  
        }
    }
    
    @IBAction func addPin(_ sender: UIGestureRecognizer) {
        if sender.state != .began { return }
        let touchPoint = sender.location(in: map)
        
        let pin = Pin(context: context)
        pin.pinCoordinate = map.convert(touchPoint, toCoordinateFrom: map)
        try? context.save()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto" {
            let controller = segue.destination as! ImagesVC
            let selectedPin = sender as! Pin
            controller.pin = selectedPin
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedResultsController.fetchedObjects?.filter {
            $0.correspond(to: view.annotation!.coordinate)
        }.first!
        performSegue(withIdentifier: "toPhoto", sender: pin)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMapView()
    }
    
}

