//
//  MyCustomPin.swift
//  TBDeputy
//
//  Created by Tushar on 16/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation
import MapKit

class MyCustomPin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subTitle : String?
    
    init(pinTitle: String, pinSubTitle: String, pinCoordinate: CLLocationCoordinate2D) {
        
        self.title = pinTitle
        self.subTitle = pinSubTitle
        self.coordinate = pinCoordinate
    }
}
