//
//  MapViewController.swift
//  TBDeputy
//
//  Created by Tushar on 16/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var shifts: [ShiftInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Map view"
        
        self.mapView.delegate = self
        self.mapView.isZoomEnabled = true
        
        //Add all the shifts start and end points to map
        addShiftLocationToMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addShiftLocationToMap() {
        
        if let shifts = self.shifts, shifts.count > 0 {
            
            var overlaysArray = [MKOverlay]()
            for info in self.shifts! {
                
                // Create start location coordinate and add pin/annotation to map
                let sourceLocation = CLLocationCoordinate2D(latitude: Double.init(info.startLatitude)!, longitude: Double.init(info.startLongitude)!)
                let title = (info.id == nil || info.id == 0) ? "Current shift start" : "Shift \(String(describing: info.id)) start"
                let sourcePin = MyCustomPin(pinTitle: title, pinSubTitle: "", pinCoordinate: sourceLocation)
                self.mapView.addAnnotation(sourcePin)
                
                // Create end location coordinate and add pin/annotation to map
                if let endLatitude = info.endLatitude, endLatitude != "0.00000", let endLongitude = info.endLongitude, endLongitude != "0.00000" {
                    let endLocation = CLLocationCoordinate2D(latitude: Double.init(endLatitude)!, longitude: Double.init(endLongitude)!)
                    let destinationPin = MyCustomPin(pinTitle: "End point", pinSubTitle: "", pinCoordinate: endLocation)
                    self.mapView.addAnnotation(destinationPin)
                    
                    // To draw line between start and end point
                    let line = MKPolyline(coordinates: [sourceLocation, endLocation], count: 2)
                    overlaysArray.append(line)
                }
            }
            
            // Zoom map to show all the added Annotations
            MKMapView.zoomMapForAnnotations(for: self.mapView)
            self.mapView.addOverlays(overlaysArray)
        } else {
            
            AlertError.showMessage(title: "Error", msg: "No shifts availabel to display on map")
        }
    }

    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyLineRender = MKPolylineRenderer(overlay: overlay)
        polyLineRender.strokeColor = UIColor.orange.withAlphaComponent(0.5)
        polyLineRender.lineWidth = 1.5
        return polyLineRender
    }
}
