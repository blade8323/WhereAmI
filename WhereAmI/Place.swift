//
//  Place.swift
//  WhereAmI
//
//  Created by Владислав Соколов on 10.09.2020.
//  Copyright © 2020 Владислав Соколов. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
