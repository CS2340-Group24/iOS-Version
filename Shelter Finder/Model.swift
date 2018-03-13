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
    
    static var userList: UserList = UserList()
    
    static func configure() {
        DataLoader.start()
        DataLoader.loadUsers()
    }
    
    static func addUser(user: User) {
        userList.addUser(user: user)
    }
    
    static func createUser(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender) {
        let user = User(number: userList.numUsers(), username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
        userList.addUser(user: user)
        DataLoader.saveUser(user: user)
    }
    
    static func addUser(number: Int, username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender) {
        let user = User(number: number, username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
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
    }
    
}
