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
    
    static var location: [Double]? = [33.774875, -84.397222]
    private(set) static var user: User?
    static var shelters: [Shelter] = []
    static var shelterDictionary: [Int : Shelter] = [:]
    private static var searchedShelters: [Shelter] = []
    static var currentShelter: Shelter?
    
    static func configure() {
        DataLoader.start()
        DataLoader.loadShelters()
    }
    
    /**
     * Attempts to find user with username user. If successful, performs action with the found user, otherwise performs other
     */
    static func findUser(username: String, action: @escaping (User) -> Void, other: @escaping () -> Void) {
        DataLoader.findUser(username: username, action: action, other: other)
    }
    
    static func createUser(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender) {
        let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
        //userList.addUser(user: user)
        DataLoader.saveUser(user: user)
    }
    
    static func setUser(user: User, action: @escaping () -> Void) {
        self.user = user
        DataLoader.userLoadReservation(username: user.username, action: action)
    }
    
    static func addShelter(key: Int, name: String, capacity: String, numericCapacity: Int, restrictions: String, longitude: Double, latitude: Double, address: String, notes: String, phone: String) {
        let newShelter = Shelter(key: key, name: name, capacity: capacity, numericCapacity: numericCapacity, restrictions: restrictions, longitude: longitude, latitude: latitude, address: address, notes: notes, phone: phone)
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
    
    /*static func userAddReservation(reservation: Reservation) {
        if let thisUser = user {
            thisUser.reservation = reservation
        }
    }*/
    
}
