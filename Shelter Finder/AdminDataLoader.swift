//
//  AdminDataLoader.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/23/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import Foundation
import Firebase

class AdminDataLoader {
    
    private static var ref: DatabaseReference!
    
    static func start() {
        ref = Database.database().reference()
    }
    
    static func loadUsers(completionAction: @escaping () -> Void) {
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            if value == nil {
                return
            }
            for (key, userValue) in value! {
                let username = key as? String
                let userDict = userValue as? NSDictionary
                if userDict == nil || username == nil {
                    return
                }
                
                let password = userDict?["Password"] as? String ?? ""
                let firstName = userDict?["First Name"] as? String ?? ""
                let lastName = userDict?["Last Name"] as? String ?? ""
                let genderString = userDict?["Gender"] as? String ?? ""
                let gender: Gender
                if let currentGender = Gender(rawValue: genderString) {
                    gender = currentGender
                } else {
                    gender = Gender.notSpecified
                }
                let userString = userDict?["User Type"] as? String ?? ""
                let userType: UserType
                if let currentType = UserType(rawValue: userString) {
                    userType = currentType
                } else {
                    userType = UserType.general
                }
                let dob = userDict?["Date of Birth"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateOfBirth = dateFormatter.date(from: dob)!
                let banned: Bool
                if "True" == (userDict?["Banned"] as? String ?? "") {
                    banned = true
                } else {
                    banned = false
                }
                let user = User(username: username!, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, userType: userType, banned: banned)
                if !("" == (userDict?["New Password"] as? String ?? "")) {
                    user.newPassword = userDict?["New Password"] as? String ?? ""
                }
                
                AdminModel.loadUser(user: user)
            }
            completionAction()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
