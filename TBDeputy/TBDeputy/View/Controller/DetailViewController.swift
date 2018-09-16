//
//  DetailViewController.swift
//  TBDeputy
//
//  Created by Tushar on 15/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var shiftInfo: ShiftInfo?
    
    func configureView() {
        
        // Update the user interface with Shift Info
        if let detail = shiftInfo {
            
            if let label = startTimeLabel {
                label.text = "Shift started at \(detail.getFormattedDate(dateStr: detail.start))"
            }
        
            if let label2 = endTimeLabel {
                if let end = detail.end, end.count > 0 {
                    label2.text = "Shift finished at \(detail.getFormattedDate(dateStr: detail.end))"
                } else {
                    label2.text = "Shift is in progress"
                }
            }
            
            let sourceLocation = CLLocationCoordinate2D(latitude: Double.init(detail.startLatitude)!, longitude: Double.init(detail.startLongitude)!)
            let sourcePin = MyCustomPin(pinTitle: "Start point", pinSubTitle: "", pinCoordinate: sourceLocation)
            self.mapView.addAnnotation(sourcePin)
            
            if let endLatitude = detail.endLatitude, endLatitude != "0.00000", let endLongitude = detail.endLongitude, endLongitude != "0.00000" {
                let endLocation = CLLocationCoordinate2D(latitude: Double.init(endLatitude)!, longitude: Double.init(endLongitude)!)
                
                let destinationPin = MyCustomPin(pinTitle: "End point", pinSubTitle: "", pinCoordinate: endLocation)
                self.mapView.addAnnotation(destinationPin)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        MKMapView.zoomMapForAnnotations(for: self.mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

