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
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
}
