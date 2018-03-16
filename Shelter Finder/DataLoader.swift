//
//  DataLoader.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/9/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation
import Firebase

class DataLoader {
    
    private static var ref: DatabaseReference!
    
    static func start() {
        ref = Database.database().reference()
    }
    
    /**
     * Attempts to find user with username user. If successful, performs action with the found user, otherwise performs other
     */
    static func findUser(username: String, action: @escaping (User) -> Void, other: @escaping () -> Void) {
        ref.child("Users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let password = value?["Password"] as? String ?? ""
            if password != "" {
                let firstName = value?["First Name"] as? String ?? ""
                let lastName = value?["Last Name"] as? String ?? ""
                let genderString = value?["Gender"] as? String ?? ""
                let gender: Gender
                if let currentGender = Gender(rawValue: genderString) {
                    gender = currentGender
                } else {
                    gender = Gender.notSpecified
                }
                let dob = value?["Date of Birth"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateOfBirth = dateFormatter.date(from: dob)!
                let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
                
                action(user)
            } else {
                other()
            }
        }) { (error) in
            print(error.localizedDescription)
            other()
        }
    }
    
    static func loadShelters() {
        
        loadAShelter(index: 0)
    }
    
    private static func loadAShelter(index: Int) {
        ref.child("Shelters").child("\(index)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get shelter value
            let value = snapshot.value as? NSDictionary
            let name = value?["Shelter Name"] as? String ?? ""
            print("\"" + name + "\"")
            if name != "" {
                let capacity = value?["Capacity"] as? String ?? ""
                let restrictions = value?["Restrictions"] as? String ?? ""
                let longitudeString = value?["Longitude"] as? String ?? ""
                let longitude = Double(longitudeString)
                let latitudeString = value?["Latitude"] as? String ?? ""
                let latitude = Double(latitudeString)
                let address = value?["Address"] as? String ?? ""
                let notes = value?["Special Notes"] as? String ?? ""
                let phone = value?["Phone Number"] as? String ?? ""
                Model.addShelter(key: index, name: name, capacity: capacity, restrictions: restrictions, longitude: longitude!, latitude: latitude!, address: address, notes: notes, phone: phone)
                loadAShelter(index: index + 1)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    public static func saveUser(user: User) {
        ref.child("Users").child(user.username).child("Password").setValue(user.password)
        ref.child("Users").child(user.username).child("First Name").setValue(user.firstName)
        ref.child("Users").child(user.username).child("Last Name").setValue(user.lastName)
        ref.child("Users").child(user.username).child("Gender").setValue(user.gender.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        ref.child("Users").child(user.username).child("Date of Birth").setValue(dateFormatter.string(from: user.dateOfBirth))
    }
    
}
