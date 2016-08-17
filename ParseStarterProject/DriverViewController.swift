//
//  DriverViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Júlio Gabriel Chilela on 8/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit
class DriverViewController: UITableViewController, CLLocationManagerDelegate {

        var usernames = [String]()
        var locations = [CLLocationCoordinate2D]()
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var locationManager: CLLocationManager!
    
    var distances = [CLLocationDistance]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        //print("rider view controller")

        
        
        
        
       
    }
    
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        
        var location:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        print("locations = \(location.latitude) \(location.longitude)")
        
        
        var query = PFQuery(className:"driverLocation")
        query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                
                if let objects = objects as? [PFObject]! {
                    
                    if objects.count > 0 {
                        
                        for object in objects {
                            
                            
                            var query = PFQuery(className:"driverLocation")
                            query.getObjectInBackgroundWithId(object.objectId!) {
                                (object: PFObject?, error: NSError?) -> Void in
                                if error != nil {
                                    print(error)
                                } else if let object = object {
                                    
                                    object["driverLocation"] = PFGeoPoint(latitude:location.latitude, longitude:location.longitude)
                                    
                                    
                                    object.saveInBackground()
                                    
                                    
                                    
                                }
                            }
                            
                        }
                        
                    } else {
                        
                        var driverLocation = PFObject(className:"driverLocation")
                        driverLocation["username"] = PFUser.currentUser()?.username
                        driverLocation["driverLocation"] = PFGeoPoint(latitude:location.latitude, longitude:location.longitude)
                        
                        
                        driverLocation.saveInBackground()
                        
                    }
                }
            } else {
                
                print(error)
            }
        })

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        query = PFQuery(className:"riderRequest")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude))
        query.limit = 10
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                //print("successfully retrieved")
                
                if let objects = objects as? [PFObject]! {
                    
                    self.usernames.removeAll()
                    self.locations.removeAll()
                    
                    for object in objects {
                        if object["driverResponded"] == nil {
                        
                        if let username = object["username"] as? String {
                            
                            self.usernames.append(username)
                            
                        }
                        if let returnedlocation = object["location"] as? PFGeoPoint {
                            
                            
                            
                            let requestLocation = CLLocationCoordinate2DMake(returnedlocation.latitude, returnedlocation.longitude)
                            
                            
                            self.locations.append(requestLocation)
                            
                            
                            let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                            
                            
                            
                            
                            let driverCLLocation =  CLLocation(latitude: self.latitude, longitude: self.longitude)
                            
                            
                            let distance  = driverCLLocation.distanceFromLocation(requestCLLocation)
                            
                            self.distances.append(distance/1000)
                        }
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                    //print(self.locations)
                    //print(self.usernames)
                    
                }
                
                
            }else {
                
                //print(error)
            }
        })
        

        
        
        }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogoutDriver" {
            locationManager.stopUpdatingLocation()
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
            
            //print("Usuario corrente logout\(PFUser.currentUser())")
            
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)

        } else if segue.identifier == "showViewRequests" {
            
        
            if let destination = segue.destinationViewController as? RequestViewController {
                           
                destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
                
                destination.requestUsername = usernames[(tableView.indexPathForSelectedRow?.row)!]
                

            
            }
        
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var distanceDouble = Double(distances[indexPath.row])
        
        var roundedDistance = Double(round(distanceDouble * 10)/10)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = usernames[indexPath.row] + " - " + String(roundedDistance) + " km away "
        
        return cell
    }
    
    
    
}
