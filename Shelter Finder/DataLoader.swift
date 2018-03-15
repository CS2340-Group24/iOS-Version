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
    
    static func findUser(username: String, action: @escaping (User) -> Void) {
        ref.child("Users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let password = value?["Password"] as? String ?? ""
            print("\"" + password + "\"")
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
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func loadUsers() {
        
        loadAUser(index: 0)
        
        /*var index = 0
        var hasAnother = true
        
        repeat {
            
        } while hasAnother
        */
        /*ref.child("Users").child("1").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let password = value?["Password"] as? String ?? ""
            print("Working")
            print("\"" + password + "\"")
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        print("After?")*/
        
        
        /*ref.child("test").setValue(["example": "wow"])
        
        ref.child("test").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let example = value?["example"] as? String ?? ""
            print(example)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }*/
    }
    
    private static func loadAUser(index: Int) {
        ref.child("Users").child("\(index)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["Username"] as? String ?? ""
            print("\"" + username + "\"")
            if username != "" {
                let password = value?["Password"] as? String ?? ""
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
                Model.addUser(number: index, username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
                loadAUser(index: index + 1)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /*public static func saveUser(user: User) {
        ref.child("Users").child("\(user.number)").child("Username").setValue(user.username)
        ref.child("Users").child("\(user.number)").child("Password").setValue(user.password)
        ref.child("Users").child("\(user.number)").child("First Name").setValue(user.firstName)
        ref.child("Users").child("\(user.number)").child("Last Name").setValue(user.lastName)
        ref.child("Users").child("\(user.number)").child("Gender").setValue(user.gender.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        ref.child("Users").child("\(user.number)").child("Date of Birth").setValue(dateFormatter.string(from: user.dateOfBirth))
    }*/
    
}
