//
//  LoginViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/20/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func login(_ sender: UIButton) {
        let username: String = usernameTextField.text!
        Model.findUser(username: username, action: {user in
            if self.passwordTextField.text == user.password {
                Model.user = user
                let alert = UIAlertController(title: "Login Successful", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "LoggedInView") as! LoggedInViewController
                    self.present(next, animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.presentAlert(title: "Incorrect username or password", message: "")
            }
        }, other: {_ in
            self.presentAlert(title: "Incorrect username or password", message: "")
        })
    }
    
}
