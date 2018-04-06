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
                let userString = value?["User Type"] as? String ?? ""
                let userType: UserType
                if let currentType = UserType(rawValue: userString) {
                    userType = currentType
                } else {
                    userType = UserType.general
                }
                let dob = value?["Date of Birth"] as? String ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let dateOfBirth = dateFormatter.date(from: dob)!
                let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, userType: userType)
                
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
            //print("\"" + name + "\"")
            if name != "" {
                let capacity = value?["Capacity"] as? String ?? ""
                let numericCapacity = Int(value?["Numeric Capacity"] as? String ?? "")
                let available = Int(value?["Available"] as? String ?? "")
                let restrictions = value?["Restrictions"] as? String ?? ""
                let longitudeString = value?["Longitude"] as? String ?? ""
                let longitude = Double(longitudeString)
                let latitudeString = value?["Latitude"] as? String ?? ""
                let latitude = Double(latitudeString)
                let address = value?["Address"] as? String ?? ""
                let notes = value?["Special Notes"] as? String ?? ""
                let phone = value?["Phone Number"] as? String ?? ""
                Model.addShelter(key: index, name: name, capacity: capacity, numericCapacity: numericCapacity!, available: available!, restrictions: restrictions, longitude: longitude!, latitude: latitude!, address: address, notes: notes, phone: phone)
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
        ref.child("Users").child(user.username).child("User Type").setValue(user.userType.rawValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        ref.child("Users").child(user.username).child("Date of Birth").setValue(dateFormatter.string(from: user.dateOfBirth))
    }
    
    static func userLoadReservation(username: String, action: @escaping () -> Void) {
        ref.child("Users").child(username).child("Reservation").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value1 = snapshot.value as? String ?? ""
            if let reservationNum = Int(value1) {
                if reservationNum != -1 {
                    ref.child("Reservations").child("\(reservationNum)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        
                        let bedsString = value?["Beds"] as? String ?? ""
                        if bedsString != "" {
                            let beds = Int(bedsString)!
                            
                            let shelterIndex = Int(value?["Shelter"] as? String ?? "")!
                            
                            let username = value?["User"] as? String ?? ""
                            print("Reading complete")
                            if let currentUser = Model.user {
                                if currentUser.username == username {
                                    if shelterIndex >= 0 && shelterIndex < Model.numberOfShelters() {
                                        _ = Reservation(user: currentUser, shelter: Model.getShelter(index: shelterIndex), beds: beds)
                                        //print(reservation.shelter!.name)
                                        //Model.userAddReservation(reservation: reservation)
                                    } else {
                                        _ = Reservation(user: currentUser, shelter: shelterIndex, beds: beds)
                                        //Model.userAddReservation(reservation: reservation)
                                    }
                                } else {
                                    if shelterIndex >= 0 && shelterIndex < Model.numberOfShelters() {
                                        _ = Reservation(user: username, shelter: Model.getShelter(index: shelterIndex), beds: beds)
                                        //Model.userAddReservation(reservation: reservation)
                                    } else {
                                        _ = Reservation(user: username, shelter: shelterIndex, beds: beds)
                                        //Model.userAddReservation(reservation: reservation)
                                    }
                                }
                                
                            }
                            
                        }
                        action()
                    }) { (error) in
                        print(error.localizedDescription)
                        action()
                    }
                }
            }
            action()
        }) { (error) in
            print(error.localizedDescription)
            action()
        }
    }
    
    /*static func loadReservations(user: User) {
        ref.child("Users").child(user.username).child("Reservations").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let indexString = value?["1"] as? String ?? ""
            if indexString != "" {
                let index = Int(indexString)!
                loadReservation(index: index, userIndex: 1, action: { (reservation, userIndex) in
                    let newUserIndex = userIndex + 1
                    let newIndexString = value?["\(newUserIndex)"] as? String ?? ""
                    if newIndexString != "" {
                        let newIndex = Int(newIndexString)!
                    }
                })
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }*/
    
    /*static func userLoadReservation(username: String) {
        ref.child("Users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            userLoadAReservation(userValue: value, userIndex: 1)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func userLoadAReservation(userValue: NSDictionary?, userIndex: Int) {
        print("Trying \(userIndex)")
        
        let reservations = userValue?["Reservations"] as? [String] ?? []
        if userIndex > 0 && userIndex < reservations.count {
            let indexString = reservations[userIndex]
            let index = Int(indexString)!
            print("Reservation \(index)")
            
            ref.child("Reservations").child("\(index)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let bedsString = value?["Beds"] as? String ?? ""
                if bedsString != "" {
                    let beds = Int(bedsString)!
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    let start = value?["Start date"] as? String ?? ""
                    let startDate = dateFormatter.date(from: start)!
                    
                    let end = value?["End date"] as? String ?? ""
                    let endDate = dateFormatter.date(from: end)!
                    
                    let shelterIndex = Int(value?["Shelter"] as? String ?? "")!
                    
                    let username = value?["User"] as? String ?? ""
                    print("Reading complete")
                    if let currentUser = Model.user {
                        if currentUser.username == username {
                            if shelterIndex >= 0 && shelterIndex < Model.numberOfShelters() {
                                let reservation = Reservation(user: currentUser, shelter: Model.getShelter(index: shelterIndex), beds: beds, startDate: startDate, endDate: endDate)
                                print(reservation.shelter!.name)
                                Model.userAddReservation(reservation: reservation)
                            } else {
                                let reservation = Reservation(user: currentUser, shelter: shelterIndex, beds: beds, startDate: startDate, endDate: endDate)
                                Model.userAddReservation(reservation: reservation)
                            }
                        } else {
                            if shelterIndex >= 0 && shelterIndex < Model.numberOfShelters() {
                                let reservation = Reservation(user: username, shelter: Model.getShelter(index: shelterIndex), beds: beds, startDate: startDate, endDate: endDate)
                                Model.userAddReservation(reservation: reservation)
                            } else {
                                let reservation = Reservation(user: username, shelter: shelterIndex, beds: beds, startDate: startDate, endDate: endDate)
                                Model.userAddReservation(reservation: reservation)
                            }
                        }
                        userLoadAReservation(userValue: userValue, userIndex: userIndex + 1)
                    }
                    
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }*/
    
}
