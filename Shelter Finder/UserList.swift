//
//  UserList.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class UserList {
    
    private(set) static var userList: [User] = []
    
    static func addUser(user: User) {
        userList.append(user)
    }
    
    static func removeUser(user: User) {
        if let index = userList.index(where: {$0.username == user.username}) {
            userList.remove(at: index)
        }
    }
    
    static func contains(user: User) -> Bool {
        return userList.contains(where: {$0.username == user.username})
    }
    
    static func contains(user: String) -> Bool {
        return userList.contains(where: {$0.username == user})
    }
    
    static func getUser(username: String) -> User? {
        if let index = userList.index(where: {$0.username == username}) {
            return userList[index]
        } else {
            return nil
        }
    }
    
}
