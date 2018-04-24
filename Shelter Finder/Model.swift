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
    
    static var wasErrorLoading = false
    
    static var nextEmptyReservation: Int = 1
    
    // Latitude, Longitude
    static var location: [Double]? {//= [33.774875, -84.397222] {
        didSet {
            for shelter in shelters {
                shelter.updateDistance()
            }
            updateSearchedSelters()
            if let action = onLocationUpdate {
                action()
            }
        }
    }
    static var onLocationUpdate: (() -> Void)?
    static let locationManager = LocationManager()
    
    private(set) static var user: User? {
        didSet {
            if let theUser = user {
                if theUser.userType == UserType.admin {
                    AdminModel.configure()
                }
                if let _ = failedLogins[theUser.username] {
                    failedLogins[theUser.username] = 0
                }
            }
        }
    }
    
    private(set) static var failedLogins: [String : Int] = [:]
    
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
        locationManager.requestAuthorization()
    }
    
    /**
     * Attempts to find user with username user. If successful, performs action with the found user, otherwise performs other
     */
    static func findUser(username: String, action: @escaping (User) -> Void, other: @escaping () -> Void) {
        DataLoader.findUser(username: username, action: action, other: other)
    }
    
    static func createUser(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, userType: UserType, banned: Bool) {
        let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, userType: userType, banned: banned)
        //userList.addUser(user: user)
        DataLoader.saveUser(user: user)
    }
    
    static func setUser(user: User, action: @escaping () -> Void) {
        self.user = user
        DataLoader.userLoadReservation(user: user, action: action)
    }
    
    /**
     * Returns whether username has been banned
     */
    static func addFailedLogin(username: String) -> Bool {
        if let current = failedLogins[username] {
            failedLogins[username] = current + 1
            if current + 1 >= 3 {
                lockUser(username: username)
                return true
            }
            return false
        } else {
            failedLogins[username] = 1
            return false
        }
    }
    
    static func lockUser(username: String) {
        findUser(username: username, action: { (user) in
            user.banned = true
            AdminDataLoader.saveUser(user: user)
        }, other: { () in
            
        })
    }
    
    static func requestUnlock(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, success: @escaping () -> Void, failure: @escaping () -> Void) {
        findUser(username: username, action: {(user) in
            let cal = Calendar(identifier: .gregorian)
            let sameDay = cal.isDate(dateOfBirth, inSameDayAs: user.dateOfBirth)
            if user.firstName == firstName && user.lastName == lastName && sameDay && user.gender == gender {
                user.newPassword = password
                AdminDataLoader.saveUser(user: user)
                success()
            } else {
                failure()
            }
        }, other: {() in
            failure()
        })
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
