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
    var numericCapacity: Int
    var restrictions: String
    var longitude: Double
    var latitude: Double
    var address: String
    var notes: String
    var phone: String
    var distance: Double?
    var currentAvailable: Int
    var reservations: [Int: Reservation]
    var nextEmptyReservation: Int
    
    init(key: Int, name: String, capacity: String, numericCapacity: Int, available: Int, restrictions: String, longitude: Double, latitude: Double, address: String, notes: String, phone: String, nextEmptyReservation: Int) {
        self.key = key
        self.name = name
        self.capacity = capacity
        self.restrictions = restrictions
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.notes = notes
        self.phone = phone
        self.numericCapacity = numericCapacity
        
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
        
        currentAvailable = available
        self.nextEmptyReservation = nextEmptyReservation
        reservations = [:]
    }
    
    func loadReservation(reservation: Reservation, index: Int) {
        reservations[index] = reservation
    }
    
    func addReservation(reservation: Reservation) {
        reservations[nextEmptyReservation] = reservation
        Model.getNextEmptyReservation(shelter: self, previousEmpty: nextEmptyReservation, action: { (nextEmpty) in
            self.nextEmptyReservation = nextEmpty
            DataLoader.setNextEmptyReservation(nextEmptyReservation: self.nextEmptyReservation, shelter: self)
        })
    }
    
}
