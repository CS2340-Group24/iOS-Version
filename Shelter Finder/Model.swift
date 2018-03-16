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
    
    static var user: User?
    static var shelters: [Shelter] = []
    
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
    
    static func addShelter(key: Int, name: String, capacity: String, restrictions: String, longitude: Double, latitude: Double, address: String, notes: String, phone: String) {
        shelters.append(Shelter(key: key, name: name, capacity: capacity, restrictions: restrictions, longitude: longitude, latitude: latitude, address: address, notes: notes, phone: phone))
    }
    
    /*static func addUser(number: Int, username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender) {
        let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
        userList.addUser(user: user)
    }
    
    static func removeUser(username: String) {
        userList.removeUser(username: username)
    }
    
    static func contains(username: String) -> Bool {
        return userList.contains(user: username)
    }
    
    static func getUser(username: String) -> User? {
        return userList.getUser(username:username)
    }*/
    
}
