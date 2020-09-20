//
//  CustomMapMarker.swift
//  JanithN-COBSCCOMP191-029
//
//  Created by Janith Navinna on 9/20/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import Foundation
import MapKit

class CustomMapMarker: NSObject, MKAnnotation
{
    // 3
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    // 4
    init(coor: CLLocationCoordinate2D)
    {
        coordinate = coor
    }
    
}
