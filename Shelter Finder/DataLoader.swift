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
                let banned: Bool
                if "True" == (value?["Banned"] as? String ?? "") {
                    banned = true
                } else {
                    banned = false
                }
                let user = User(username: username, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, userType: userType, banned: banned)
                if !("" == (value?["New Password"] as? String ?? "")) {
                    user.newPassword = value?["New Password"] as? String ?? ""
                }
                
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
                let nextEmptyReservation = Int(value?["Next Empty Reservation"] as? String ?? "")
                Model.addShelter(key: index, name: name, capacity: capacity, numericCapacity: numericCapacity!, available: available!, restrictions: restrictions, longitude: longitude!, latitude: latitude!, address: address, notes: notes, phone: phone, nextEmptyReservation: nextEmptyReservation!)
                loadAShelter(index: index + 1)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
            Model.wasErrorLoading = true
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
        if let reservation = user.reservation {
            ref.child("Users").child(user.username).child("Reservation").setValue("\(reservation.reservationIndex)")
        } else {
            ref.child("Users").child(user.username).child("Reservation").setValue("-1")
        }
        if user.banned {
            ref.child("Users").child(user.username).child("Banned").setValue("True")
        } else {
            ref.child("Users").child(user.username).child("Banned").setValue("False")
        }
        if let newPassword = user.newPassword {
            ref.child("Users").child(user.username).child("New Password").setValue(newPassword)
        } else {
            ref.child("Users").child(user.username).child("New Password").setValue("")
        }
    }
    
    static func userLoadReservation(user: User, action: @escaping () -> Void) {
        ref.child("Users").child(user.username).child("Reservation").observeSingleEvent(of: .value, with: { (snapshot) in
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
                            let shelter = Model.getShelter(index: shelterIndex)
                            let reservationShelterIndex = Int(value?["Reservation Shelter Index"] as? String ?? "")!
                            
                            //let username = value?["User"] as? String ?? ""
                            print("Reading complete")
                            
                            _ = Reservation(reservationIndex: reservationNum, user: user, shelter: shelter, shelterIndex: reservationShelterIndex, beds: beds)
                            /*if let currentUser = Model.user {
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
                                
                            }*/
                            
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
    
    static func createReservation(reservation: Reservation) {
        ref.child("Reservations").child("\(reservation.reservationIndex)").child("Beds").setValue("\(reservation.beds)")
        ref.child("Reservations").child("\(reservation.reservationIndex)").child("Reservation Shelter Index").setValue("\(reservation.shelterIndex)")
        ref.child("Reservations").child("\(reservation.reservationIndex)").child("Shelter").setValue("\(reservation.shelter.key)")
        ref.child("Reservations").child("\(reservation.reservationIndex)").child("User").setValue(reservation.user.username)
        ref.child("Users").child(reservation.user.username).child("Reservation").setValue("\(reservation.reservationIndex)")
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Reservations").child("\(reservation.shelterIndex)").setValue("\(reservation.reservationIndex)")
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Available").setValue("\(reservation.shelter.currentAvailable)")
    }
    
    static func modifyReservation(reservation: Reservation) {
        ref.child("Reservations").child("\(reservation.reservationIndex)").child("Beds").setValue("\(reservation.beds)")
        //ref.child("Reservations").child("\(reservation.reservationIndex)").child("Shelter").setValue("\(reservation.shelter.key)")
        //ref.child("Reservations").child("\(reservation.reservationIndex)").child("User").setValue(reservation.user.username)
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Available").setValue("\(reservation.shelter.currentAvailable)")
    }
    
    static func deleteReservation(reservation: Reservation) {
        ref.child("Users").child(reservation.user.username).child("Reservation").setValue("-1")
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Reservations").child("\(reservation.shelterIndex)").setValue("-1")
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Next Empty Reservation").setValue("\(reservation.shelter.nextEmptyReservation)")
        ref.child("Shelters").child("\(reservation.shelter.key)").child("Available").setValue("\(reservation.shelter.currentAvailable)")
        ref.child("Reservations").child("\(reservation.reservationIndex)").setValue("Deleted")
    }
    
    static func setNextEmptyReservation(nextEmptyReservation: Int) {
        ref.child("Next Empty Reservation").setValue("\(nextEmptyReservation)")
    }
    
    static func getNextEmptyReservation(previousEmpty: Int, action: @escaping (Int) -> Void) {
        if (previousEmpty == -1) {
            ref.child("Next Empty Reservation").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String ?? ""
                let index = Int(value)
                if let indeX = index {
                    action(indeX)
                }
            }) { (error) in
                print(error.localizedDescription)
                action(-1)
            }
        } else {
            ref.child("Reservations").child("\(previousEmpty)").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String ?? ""
                let dict = snapshot.value as? NSDictionary
                let isDict: Bool
                if let _ = dict {
                    isDict = true
                } else {
                    isDict = false
                }
                if value == "Deleted" || !(isDict && value == "") {
                    action(previousEmpty)
                } else {
                    getNextEmptyReservation(previousEmpty: previousEmpty + 1, action: action)
                }
            }) { (error) in
                print(error.localizedDescription)
                action(-1)
            }
        }
    }
    
    static func setNextEmptyReservation(nextEmptyReservation: Int, shelter: Shelter) {
        ref.child("Shelters").child("\(shelter.key)").child("Next Empty Reservation").setValue("\(nextEmptyReservation)")
    }
    
    static func getNextEmptyReservation(shelter: Shelter, previousEmpty: Int, action: @escaping (Int) -> Void) {
        ref.child("Shelters").child("\(shelter.key)").child("Reservations").child("\(previousEmpty)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String ?? ""
            if value == "-1" || value == "" {
                action(previousEmpty)
            } else {
                getNextEmptyReservation(shelter: shelter, previousEmpty: previousEmpty + 1, action: action)
            }
        }) { (error) in
            print(error.localizedDescription)
            action(-1)
        }
    }
    
}
