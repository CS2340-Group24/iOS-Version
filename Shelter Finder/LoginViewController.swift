//
//  LoginViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/20/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            //NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWithRequest(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            //NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Request Access", comment: "Request Access"), style: .`default`, handler: { _ in
            let next = self.storyboard?.instantiateViewController(withIdentifier: "SecurityQuestionsView") as! SecurityQuestionsViewController
            self.present(next, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: UIButton) {
        let username: String = usernameTextField.text!
        let locked = Model.addFailedLogin(username: username)
        if locked {
            self.presentAlertWithRequest(title: "Too many incorrect login attempts", message: "Account has been locked.")
        } else {
            Model.findUser(username: username, action: {user in
                if user.banned {
                    self.presentAlertWithRequest(title: "This account is locked", message: "")
                } else {
                    if self.passwordTextField.text == user.password {
                        Model.setUser(user: user, action: { _ in
                            let alert = UIAlertController(title: "Login Successful", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                //NSLog("The \"OK\" alert occured.")
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
                                self.present(next, animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        })
                    } else {
                        self.presentAlert(title: "Incorrect username or password", message: "")
                    }
                }
            }, other: {_ in
                self.presentAlert(title: "Incorrect username or password", message: "")
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            //dismissKeyboard()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            dismissKeyboard()
            if usernameTextField.text != "" && passwordTextField.text != "" {
                login(loginButton)
            }
        }
        
        return true
    }
    
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
