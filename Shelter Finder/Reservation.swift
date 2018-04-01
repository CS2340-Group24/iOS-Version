//
//  Reservation.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/1/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class Reservation {
    private(set) var user: User?
    private(set) var username: String?
    private(set) var shelter: Shelter?
    private(set) var shelterIndex: Int?
    var beds: Int
    var startDate: Date
    var endDate: Date
    
    init (user: User, shelter: Shelter, beds: Int, startDate: Date, endDate: Date) {
        self.user = user
        self.shelter = shelter
        self.beds = beds
        self.startDate = startDate
        self.endDate = endDate
        
        user.addReservation(reservation: self)
    }
    
    init (user: String, shelter: Shelter, beds: Int, startDate: Date, endDate: Date) {
        self.username = user
        self.shelter = shelter
        self.beds = beds
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init (user: User, shelter: Int, beds: Int, startDate: Date, endDate: Date) {
        self.user = user
        self.shelterIndex = shelter
        self.beds = beds
        self.startDate = startDate
        self.endDate = endDate
        
        user.addReservation(reservation: self)
    }

    init (user: String, shelter: Int, beds: Int, startDate: Date, endDate: Date) {
        self.username = user
        self.shelterIndex = shelter
        self.beds = beds
        self.startDate = startDate
        self.endDate = endDate
    }
    
}
