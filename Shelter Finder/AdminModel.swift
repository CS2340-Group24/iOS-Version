//
//  AdminModel.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/22/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class AdminModel {
    
    private static var userList: UserList = UserList()
    static var currentUser: User?
    
    static func configure() {
        userList = UserList()
        AdminDataLoader.start()
        AdminDataLoader.loadUsers(completionAction: {() in
            
        })
    }
    
    static func loadUser(user: User) {
        userList.addUser(user: user)
    }
    
    static func numberOfUsers() -> Int {
        return userList.numUsers()
    }
    
    static func getUser(index: Int) -> User {
        return userList.getUser(index: index)
    }
    
}
