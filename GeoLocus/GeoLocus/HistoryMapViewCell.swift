//
//  HistoryMapViewCell.swift
//  GeoLocus
//
//  Created by CTS MAC on 30/01/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation : NSObject, MKAnnotation {
    var coordinate    : CLLocationCoordinate2D
    var annotationID  : Int
    
    init(coordinate: CLLocationCoordinate2D, annotationID: Int) {
        self.coordinate   = coordinate
        self.annotationID = annotationID
        
    }
}

class HistoryMapViewCell: UITableViewCell {

    @IBOutlet weak var historyMapView: MKMapView!
    var delegate: MapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        historyMapView.mapType              = .Standard;
        self.historyMapView.delegate        = self
        self.historyMapView.rotateEnabled   = false
        self.historyMapView.pitchEnabled    = false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showMapAnnotations(annotations: [EventAnnotation]){
        
        self.historyMapView.removeAnnotations(self.historyMapView.annotations)
        self.historyMapView.addAnnotations(annotations)
        self.historyMapView.showAnnotations(annotations, animated: true)
        
        let region = coordinateRegion(annotations)
        self.historyMapView.regionThatFits(region)
        self.historyMapView.setRegion(region, animated: true)
    }
}

extension HistoryMapViewCell: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            let identifier = "Pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
               
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.calloutOffset = CGPoint(x: -5, y: 5)
                //view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        //print("selected....:\(view)")
        let annotation = view.annotation as! EventAnnotation
      
        let selectedAnnotation = mapView.selectedAnnotations
        
        for annotation in selectedAnnotation {
            let ann = annotation as MKAnnotation
            mapView.deselectAnnotation(ann, animated: false)
        }
        
        delegate?.mapView(self.historyMapView, didSelectAnnotation: annotation)
    }
    
    func coordinateRegion(events: [EventAnnotation]) -> MKCoordinateRegion{
        var rect = MKMapRectNull
        
        for event in events {
            let mapPoint = MKMapPointForCoordinate(event.coordinate)
            rect         = MKMapRectUnion(rect, MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0))
        }
        
        return MKCoordinateRegionForMapRect(rect)
    }
}

