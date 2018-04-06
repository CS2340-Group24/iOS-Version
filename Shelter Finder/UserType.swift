//
//  UserType.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/5/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

enum UserType: String {
    case general = "General"
    case admin = "Admin"
    case shelterEmpoyee = "Shelter Employee"
    
    static let allValues = [general.rawValue, admin.rawValue, shelterEmpoyee.rawValue]
    static let count = 3
    
    
}
