//
//  RiderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RiderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
     @IBOutlet weak var callUberButton: UIButton!
       var latitude: CLLocationDegrees = 0.0
        var longitude: CLLocationDegrees = 0.0
    
    var driverOnTheWay = false
    var riderRequestActive = false
    
    
    @available(iOS 8.0, *)
   
    @IBAction func callUber(sender: AnyObject) {
        
        if riderRequestActive == false {
        
        var riderRequest = PFObject(className:"riderRequest")
        riderRequest["username"] = PFUser.currentUser()?.username
        riderRequest["location"] = PFGeoPoint(latitude: latitude, longitude: longitude)
       
        
        riderRequest.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
                self.callUberButton.setTitle("Cancel Cupapata", forState: UIControlState.Normal)
                
                
            } else {
                let alertController = UIAlertController(title: "Could not call Cupapata", message: "Please try again", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
            riderRequestActive = true
            
        } else {
            self.callUberButton.setTitle("Call an Cupapata", forState: UIControlState.Normal)
            
            
            riderRequestActive = false
            
            let query = PFQuery(className:"riderRequest")
            
            query.whereKey("username", equalTo: (PFUser.currentUser()?.username)! )
            query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    print("successfully retrieved")
                    
                    if let objects = objects as? [PFObject]! {
                        
                        for object in objects {
                            
                            object.deleteInBackground()
                            
                        }
                        
                    }
                    
                    
                }else {
                    
                    print(error)
                }
            })

        
        }
        
        
    }
    @IBOutlet weak var map: MKMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        print("rider view controller")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        var query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                
                if let objects = objects as? [PFObject]! {
                    
                    
                    for object in objects {
                        
                        if let driverUsername = object["driverResponded"] {
                            
                            
                            var query = PFQuery(className:"driverLocation")
                            query.whereKey("username", equalTo:driverUsername)
                            
                           query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
                                if error == nil {
                                    
                                    
                                    if let objects = objects as? [PFObject]! {
                                        
                                        
                                        for object in objects {
                                            
                                            if let driverLocation = object["driverLocation"] as? PFGeoPoint {
                                                
                                                
                                                let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                                let userCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                                
                                                let distanceMeters = userCLLocation.distanceFromLocation(driverCLLocation)
                                                let distanceKM = distanceMeters / 1000
                                                let roundedTwoDigitDistance = Double(round(distanceKM * 10) / 10)
                                                
                                                self.callUberButton.setTitle("Driver is \(roundedTwoDigitDistance)km away!", forState: UIControlState.Normal)
                                                
                                                self.driverOnTheWay = true
                                                
                                                let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                                
                                                let latDelta = abs(driverLocation.latitude - location.latitude) * 2 + 0.005
                                                let lonDelta = abs(driverLocation.longitude - location.longitude) * 2 + 0.005
                                                
                                                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
                                                
                                                self.map.setRegion(region, animated: true)
                                                
                                                self.map.removeAnnotations(self.map.annotations)
                                                
                                                var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                                var objectAnnotation = MKPointAnnotation()
                                                objectAnnotation.coordinate = pinLocation
                                                objectAnnotation.title = "Your location"
                                                self.map.addAnnotation(objectAnnotation)
                                                
                                                pinLocation = CLLocationCoordinate2DMake(driverLocation.latitude, driverLocation.longitude)
                                                objectAnnotation = MKPointAnnotation()
                                                objectAnnotation.coordinate = pinLocation
                                                objectAnnotation.title = "Driver location"
                                                self.map.addAnnotation(objectAnnotation)
                                                
                                                
                                                
                                            }
                                        }
                                    }
                                }
                            })
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                    }
                }
            }
    })
        
        
        if (driverOnTheWay == false) {
            
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.map.setRegion(region, animated: true)
            
            self.map.removeAnnotations(map.annotations)
            
            var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "Your location"
            self.map.addAnnotation(objectAnnotation)
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutRider" {
            locationManager.stopUpdatingLocation()
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
        }
    }
}
