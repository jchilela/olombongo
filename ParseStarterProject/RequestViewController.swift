//
//  RequestViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class RequestViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var pickupRiderLabel: UIButton!
    @IBAction func pickUpRider(sender: AnyObject) {
        
        
        
        let query = PFQuery(className:"riderRequest")
        
        query.whereKey("username", equalTo: (requestUsername) )
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //print("successfully retrieved")
                
                if let objects = objects as? [PFObject]! {
                    
                    for object in objects {
                        
                        
                        
                        
                        let query = PFQuery(className:"riderRequest")
                        
                       
                        query.getObjectInBackgroundWithId(object.objectId!){ (object: PFObject?, error: NSError?) -> Void in
                            if error == nil {
                                //print("successfully retrieved")
                                
                                object!["driverResponded"] = PFUser.currentUser()?.username!
                                do{try object!.saveInBackground()}catch{}
                                
                                
                                let requestCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                                

                                
                                CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks, error) in
                                    
                                    
                                    if (error != nil) {
                                        print("Reverse geocoder failed with error" + error!.localizedDescription)
                                        
                                    }else{
                                    
                                    if placemarks!.count > 0 {
                                        let pm = placemarks![0] as CLPlacemark
                                        
                                     let  mkPm = MKPlacemark(placemark: pm)
                                        var mapItem = MKMapItem(placemark: mkPm)
                                        mapItem.name = self.requestUsername
                                    
                                        
                                        
                                        var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                        
                                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                                        
                                        
                                        
                                    } else {
                                        print("Problem with the data received from geocoder")
                                    }

                                    
                                    
                                    }
                                    
                                })
                                
                                
                            
                                
                                
                            
                                
                                }
                                
                            else {
                                
                                print(error)
                            }
                        }
                        
                        
                        
                        
                        
                    }
                    
                }
                
                
            }else {
                
                print(error)
            }
        })
        

        
        
    }

    var requestLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
    var requestUsername: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let center = CLLocationCoordinate2D(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = requestLocation
        objectAnnotation.title = requestUsername
        self.map.addAnnotation(objectAnnotation)

        
        
        print("coordinates------ \(requestLocation)")
        print(requestUsername)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
}
