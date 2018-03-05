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
    }
    
    
}
