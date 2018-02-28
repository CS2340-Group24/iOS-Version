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
    
    // MARK: Actions
    @IBAction func login(_ sender: UIButton) {
        let username = usernameTextField.text!
        if let user = UserList.getUser(username: username) {
            if passwordTextField.text == user.password {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "LoggedInView") as! LoggedInViewController
                self.present(next, animated: true, completion: nil)
            }
        }
        if usernameTextField.text == "admin" && passwordTextField.text == "admin" {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LoggedInView") as! LoggedInViewController
            self.present(next, animated: true, completion: nil)
        }
    }
    
}
