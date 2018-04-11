//
//  Model.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/9/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Model {
    
    static var nextEmptyReservation: Int = 1
    static var location: [Double]? = [33.774875, -84.397222]
    private(set) static var user: User?
    static var shelters: [Shelter] = []
    static var shelterDictionary: [Int : Shelter] = [:]
    private static var searchedShelters: [Shelter] = []
    static var currentShelter: Shelter?
    
    static func configure() {
        DataLoader.start()
        DataLoader.loadShelters()
        DataLoader.getNextEmptyReservation(previousEmpty: -1, action: { (nextEmpty) in
            nextEmptyReservation = nextEmpty
        })
    }
    
    /**
     * Attempts to find user with username user. If successful, performs action with the found user, otherwise performs other
     */
    static func findUser(username: String, action: @escaping (User) -> Void, other: @escaping () -> Void) {
        DataLoader.findUser(username: username, action: action, other: other)
    }
    
    static func createUser(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, userType: UserType) {
        let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, userType: userType)
        //userList.addUser(user: user)
        DataLoader.saveUser(user: user)
    }
    
    static func setUser(user: User, action: @escaping () -> Void) {
        self.user = user
        DataLoader.userLoadReservation(user: user, action: action)
    }
    
    static func addShelter(key: Int, name: String, capacity: String, numericCapacity: Int, available: Int, restrictions: String, longitude: Double, latitude: Double, address: String, notes: String, phone: String, nextEmptyReservation: Int) {
        let newShelter = Shelter(key: key, name: name, capacity: capacity, numericCapacity: numericCapacity, available: available, restrictions: restrictions, longitude: longitude, latitude: latitude, address: address, notes: notes, phone: phone, nextEmptyReservation: nextEmptyReservation)
        shelters.append(newShelter)
        shelterDictionary[key] = newShelter
    }
    
    static func numberOfShelters() -> Int {
        return shelters.count
    }
    
    static func getShelter(index: Int) -> Shelter {
        return shelters[index]
    }
    
    static func updateSearchedSelters() {
        searchedShelters = []
        var hasDistance = true
        for shelter in shelters {
            if SearchCriteria.fitsSearch(shelter: shelter) {
                searchedShelters += [shelter]
                if let _ = shelter.distance {
                    
                } else {
                    hasDistance = false
                }
            }
        }
        if hasDistance {
            searchedShelters.sort(by: { (shelter1: Shelter, shelter2: Shelter) -> Bool in
                return shelter1.distance! <= shelter2.distance!
            })
        } else {
            searchedShelters.sort(by: { (shelter1: Shelter, shelter2: Shelter) -> Bool in
                return shelter1.name <= shelter2.name
            })
        }
    }
    
    static func numberOfSearchedShelters() -> Int {
        return searchedShelters.count
    }
    
    static func getSearchedShelter(index: Int) -> Shelter {
        return searchedShelters[index]
    }
    
    static func reserve(newSpots: Int) {
        if let reservation = user!.reservation {
            if newSpots != reservation.beds {
                if newSpots == 0 {
                    // Deletes reservation
                    deleteReservation(reservation: reservation)
                } else if newSpots != reservation.beds {
                    // Modifies reservation
                    modifyReservation(reservation: reservation, newSpots: newSpots)
                }
            }
        } else {
            // Creates reservation
            createReservation(user: user!, shelter: currentShelter!, beds: newSpots)
        }
    }
    
    static func createReservation(user: User, shelter: Shelter, beds: Int) {
        let reservation = Reservation(reservationIndex: nextEmptyReservation, user: user, shelter: shelter, beds: beds)
        shelter.currentAvailable -= beds
        DataLoader.createReservation(reservation: reservation)
        DataLoader.getNextEmptyReservation(previousEmpty: nextEmptyReservation + 1, action: {(nextEmpty) in
            nextEmptyReservation = nextEmpty
            DataLoader.setNextEmptyReservation(nextEmptyReservation: nextEmptyReservation)
        })
    }
    
    static func deleteReservation(reservation: Reservation) {
        reservation.user.reservation = nil
        if reservation.shelterIndex < reservation.shelter.nextEmptyReservation {
            reservation.shelter.nextEmptyReservation = reservation.shelterIndex
        }
        reservation.shelter.currentAvailable += reservation.beds
        if reservation.reservationIndex < nextEmptyReservation {
            nextEmptyReservation = reservation.reservationIndex
        }
        DataLoader.deleteReservation(reservation: reservation)
        DataLoader.setNextEmptyReservation(nextEmptyReservation: nextEmptyReservation)
    }
    
    static func modifyReservation(reservation: Reservation, newSpots: Int) {
        reservation.shelter.currentAvailable += reservation.beds - newSpots
        reservation.beds = newSpots
        DataLoader.modifyReservation(reservation: reservation)
    }
    
    static func getNextEmptyReservation(shelter: Shelter, previousEmpty: Int, action: @escaping (Int) -> Void) {
        DataLoader.getNextEmptyReservation(shelter: shelter, previousEmpty: previousEmpty, action: action)
    }
    
}
