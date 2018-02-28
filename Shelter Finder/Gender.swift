//
//  Gender.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

enum Gender: String {
    case notSpecified = "Not Specified"
    case male = "Male"
    case female = "Female"
    
    static let allValues = [notSpecified.rawValue, male.rawValue, female.rawValue]
    static let count = 3
    
    
}
