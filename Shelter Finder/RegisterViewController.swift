//
//  RegisterViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField1: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    var gender: Gender = Gender.notSpecified
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        usernameField.delegate = self
        passwordField1.delegate = self
        passwordField2.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        // Connect data:
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Gender.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let genders = ["1", "2", "3"]
        //return genders[row]
        return Gender.allValues[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let currentGender = Gender(rawValue: Gender.allValues[row]) {
            gender = currentGender
        } else {
            gender = Gender.notSpecified
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func register(_ sender: UIButton) {
        let username = usernameField.text!
        let password1 = passwordField1.text!
        let password2 = passwordField2.text!
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let dateOfBirth = datePicker.date
        
        if username == "" || password1 == "" || password2 == "" || firstName == "" || lastName == "" {
            presentAlert(title: "Not all fields filled", message: "Please fill out all the fields")
        } else if username.contains("\"") || password1.contains("\"") || firstName.contains("\"") || lastName.contains("\"") {
            presentAlert(title: "Illegal character used", message: "Do not use the character \"")
        } else {
            Model.findUser(username: username, action: {user in
                self.presentAlert(title: "Username already taken", message: "Please choose a different username")
            }, other: {_ in
                if password1 == password2 {
                    //let newUser = User(username: username, password: password1, firstName: firstName
                    //    , lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
                    Model.createUser(username: username, password: password1, firstName: firstName
                        , lastName: lastName, dateOfBirth: dateOfBirth, gender: self.gender)
                    
                    let alert = UIAlertController(title: "Registration Successful", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        let next = self.storyboard?.instantiateViewController(withIdentifier: "StartupView") as! StartupViewController
                        self.present(next, animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.presentAlert(title: "Passwords must be the same", message: "Please retype passwords")
                }
            })
        }
        /*if !Model.contains(username: username) {
            if password1 == password2 {
                //let newUser = User(username: username, password: password1, firstName: firstName
                //    , lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
                Model.createUser(username: username, password: password1, firstName: firstName
                    , lastName: lastName, dateOfBirth: dateOfBirth, gender: gender)
                
                let alert = UIAlertController(title: "Registration Successful", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "StartupView") as! StartupViewController
                    self.present(next, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                presentAlert(title: "Passwords must be the same", message: "Please retype passwords")
            }
        } else {
            presentAlert(title: "Username already taken", message: "Please choose a different username")
        }*/
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameField {
            passwordField1.becomeFirstResponder()
        } else if textField == passwordField1 {
            passwordField2.becomeFirstResponder()
        } else if textField == passwordField2 {
            firstNameField.becomeFirstResponder()
        } else if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            dismissKeyboard()
        }
        
        return true
    }
    
}
