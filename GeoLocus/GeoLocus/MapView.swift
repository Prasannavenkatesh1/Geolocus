//
//  MapView.swift
//  GeoLocus
//
//  Created by macuser on 09/09/15.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapView : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapNavBar: UINavigationBar!
    @IBOutlet weak var map: MKMapView!
    
    let locMgr = CLLocationManager()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    
    var whichMap = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         mapNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        locMgr.requestAlwaysAuthorization()
        locMgr.startUpdatingLocation()
        locMgr.startUpdatingHeading()
        locMgr.startMonitoringSignificantLocationChanges()
    }
    
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
      
      if (error != nil) {
        print("ERROR:" + error!.localizedDescription)
        return
      }
      
      if placemarks!.count > 0 {
        let pm = placemarks![0] as! CLPlacemark
        self.displayLocationInfo(pm)
      } else {
        print("Error with data")
      }
    })
    
  }
  
    func displayLocationInfo(placemark: CLPlacemark) {
        locMgr.stopUpdatingLocation()
      
//        println(placemark.locality)
//        println(placemark.postalCode)
//        println(placemark.administrativeArea)
//        println(placemark.country)
//        println(placemark.location)
        
      latitude = placemark.location?.coordinate.latitude
      longitude = placemark.location?.coordinate.longitude
      
        self.mapDisplay()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
         print("Error:" + error.localizedDescription)
    }
    
    @IBAction func bkBtn(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func mapDisplay() {

        //Locate the User in Map
        var location = CLLocationCoordinate2DMake(latitude, longitude)
        print(location)
        
        var mapSpan = MKCoordinateSpanMake(0.04,0.04)
        var region = MKCoordinateRegionMake(location, mapSpan)
        
        //Point the User in Map
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        //Set the region in the map
        self.map.setRegion(region, animated: true)
        self.map.addAnnotation(annotation)
        
        //Search for the nearest places
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = whichMap
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        
      search.startWithCompletionHandler({(response: MKLocalSearchResponse?, error: NSError?) -> Void in
        
        if (error != nil) {
          print("Error occured in search: \(error!.localizedDescription)")
        } else if response!.mapItems.count == 0 {
          print("No matches found")
        } else {
          print("Matches found")
          
          for item in response!.mapItems as [MKMapItem] {
            print("Name = \(item.name)")
            print("Phone = \(item.phoneNumber)")
            
            self.matchingItems.append(item as MKMapItem)
            print("Matching items = \(self.matchingItems.count)")
            
            var annotations = MKPointAnnotation()
            annotations.coordinate = item.placemark.coordinate
            annotations.title = item.name
            self.map.addAnnotation(annotations)
          }
        }
      })
      
    }
  
}
