//
//  UserList.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class UserList {
    
    private(set) var userList: [User] = []
    
    func addUser(user: User) {
        userList.append(user)
    }
    
    func removeUser(username: String) {
        if let index = userList.index(where: {$0.username == username}) {
            userList.remove(at: index)
        }
    }
    
    func contains(user: User) -> Bool {
        return userList.contains(where: {$0.username == user.username})
    }
    
    func contains(user: String) -> Bool {
        return userList.contains(where: {$0.username == user})
    }
    
    func getUser(username: String) -> User? {
        if let index = userList.index(where: {$0.username == username}) {
            return userList[index]
        } else {
            return nil
        }
    }
    
    func getUser(index: Int) -> User {
        return userList[index]
    }
    
    func numUsers() -> Int {
        return userList.count
    }
    
}
