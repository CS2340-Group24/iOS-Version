//
//  SearchCriteria.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation

class SearchCriteria {
    static var search: String = "" {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var male: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var female: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var families: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var youngAdults: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var children: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    static var veterans: Bool = false {
        didSet {
            Model.updateSearchedSelters()
        }
    }
    
    static func reset() {
        search = ""
        male = false
        female = false
        families = false
        youngAdults = false
        children = false
        veterans = false
        Model.updateSearchedSelters()
    }
    
    static func fitsSearch(shelter: Shelter) -> Bool {
        if search != "" {
            let name = shelter.name.lowercased()
            let restrictions = shelter.restrictions.lowercased()
            let notes = shelter.notes.lowercased()
            let lowerSearch = search.lowercased()
            if !(name.contains(lowerSearch) || restrictions.contains(lowerSearch) || notes.contains(lowerSearch)) {
                return false;
            }
        }
        return fitsCriteria(restrictions: shelter.restrictions)
    }
    
    private static func fitsCriteria(restrictions: String) -> Bool {
        let restricts = restrictions.lowercased()
        if male {
            if !((restricts.contains("man") && !restricts.contains("woman")) || (restricts.contains("men") && !restricts.contains("women")) || (restricts.contains("male") && !restricts.contains("female")) || restricts.contains("boy")) {
                return false
            }
        }
        if female {
            if !(restricts.contains("woman") || restricts.contains("women") || restricts.contains("female") || restricts.contains("girl") || restricts.contains("lady") || restricts.contains("ladies")) {
                return false
            }
        }
        if families {
            if !(restricts.contains("family") || restricts.contains("families")) {
                return false
            }
        }
        if youngAdults {
            if !(restricts.contains("young adult")) {
                return false
            }
        }
        if children {
            if !(restricts.contains("child") || restricts.contains("kid")) {
                return false
            }
        }
        if veterans {
            if !(restricts.contains("veteran")) {
                return false
            }
        }
        return true
    }
}
