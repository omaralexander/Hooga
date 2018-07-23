//
//  coordinatesForLocations.swift
//  Hooga
//
//  Created by Omar Abbas on 4/5/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import Foundation
class mapPoints {
    var Borough : String
    var Neighborhood : String
    var latitude: Double
    var longitude: Double
    
    init(Borough: String, Neighborhood: String, Latitude: Double, Longitude: Double) {
        self.Borough = Borough
        self.Neighborhood = Neighborhood
        self.latitude = Latitude
        self.longitude = Longitude
    }
}
