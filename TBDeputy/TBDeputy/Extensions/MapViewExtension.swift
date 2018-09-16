//
//  MapViewExtension.swift
//  TBDeputy
//
//  Created by Tushar on 16/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    class func zoomMapForAnnotations(for map: MKMapView) -> Void {
        
        var zoomRect:MKMapRect = MKMapRectNull;
        let annotations = map.annotations
        for annotation in annotations {
            
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        
        map.setVisibleMapRect(zoomRect, animated: true)
    }
}
