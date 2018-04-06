//
//  User.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class User {
    
    private(set) var username: String
    private(set) var password: String
    private(set) var firstName: String
    private(set) var lastName: String
    private(set) var dateOfBirth: Date
    private(set) var gender: Gender
    private(set) var userType: UserType
    var reservation: Reservation?
    
    init(username: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, gender: Gender, userType: UserType) {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.userType = userType
    }
    
}
