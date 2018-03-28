//
//  Shelter.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/5/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class Shelter {
    
    var key: Int
    var name: String
    var capacity: String
    var restrictions: String
    var longitude: Double
    var latitude: Double
    var address: String
    var notes: String
    var phone: String
    var distance: Double?
    
    init(key: Int, name: String, capacity: String, restrictions: String, longitude: Double, latitude: Double, address: String, notes: String, phone: String) {
        self.key = key
        self.name = name
        self.capacity = capacity
        self.restrictions = restrictions
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.notes = notes
        self.phone = phone
        
        if let location = Model.location {
            let lat1 = .pi * location[0] / 180
            let lat2 = .pi * latitude / 180
            let long1 = .pi * location[1] / 180
            let long2 = .pi * longitude / 180
            let dLat = abs(lat1 - lat2)
            let dLong = abs(long1 - long2)
            let a = pow(sin(dLat/2), 2) + cos(lat1)*cos(lat2)*pow(sin(dLong/2), 2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            distance = Double(round(10 * 3959 * c) / 10)
        }
    }
    
    
}
