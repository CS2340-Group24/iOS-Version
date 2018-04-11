//
//  Reservation.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/1/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class Reservation {

    private(set) var reservationIndex: Int
    private(set) var user: User
    private(set) var shelter: Shelter
    private(set) var shelterIndex: Int  //The index of the reservation in shelter's reservation list
    var beds: Int

    /**
     * Used for loading a reservation
     */
    init (reservationIndex: Int, user: User, shelter: Shelter, shelterIndex: Int, beds: Int) {
        self.reservationIndex = reservationIndex
        self.user = user
        self.shelter = shelter
        self.shelterIndex = shelterIndex
        self.beds = beds
        
        user.reservation = self
        shelter.loadReservation(reservation: self, index: shelterIndex)
    }
    
    /**
     * Used for creating a reservation
     */
    init (reservationIndex: Int, user: User, shelter: Shelter, beds: Int) {
        self.reservationIndex = reservationIndex
        self.user = user
        self.shelter = shelter
        self.beds = beds
        
        shelterIndex = shelter.nextEmptyReservation
        
        user.reservation = self
        shelter.addReservation(reservation: self)
        
    }

    /*private(set) var user: User?
    private(set) var username: String?
    private(set) var shelter: Shelter?
    private(set) var shelterIndex: Int?
    var beds: Int
    
    init (user: User, shelter: Shelter, beds: Int) {
        self.user = user
        self.shelter = shelter
        self.beds = beds
        
        user.reservation = self
    }
    
    init (user: String, shelter: Shelter, beds: Int) {
        self.username = user
        self.shelter = shelter
        self.beds = beds
    }
    
    init (user: User, shelter: Int, beds: Int) {
        self.user = user
        self.shelterIndex = shelter
        self.beds = beds
        
        user.reservation = self
    }

    init (user: String, shelter: Int, beds: Int) {
        self.username = user
        self.shelterIndex = shelter
        self.beds = beds
    }*/
    
}
