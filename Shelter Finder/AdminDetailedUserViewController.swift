//
//  AdminDetailedUserViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/23/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class AdminDetailedUserViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var lockedLabel: UILabel!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = AdminModel.currentUser!
        usernameLabel.text = user.username
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        genderLabel.text = user.gender.rawValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateOfBirthLabel.text = dateFormatter.string(from: user.dateOfBirth)
        userTypeLabel.text = user.userType.rawValue
        if user.banned {
            lockedLabel.text = "True"
            if user.newPassword != nil {
                unlockButton.isHidden = false
                lockButton.isHidden = true
            } else {
                unlockButton.isHidden = true
                lockButton.isHidden = false
            }
        } else {
            lockedLabel.text = "False"
            unlockButton.isHidden = true
            lockButton.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK : Actions
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "What should the new user type be?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("General", comment: "general"), style: .`default`, handler: { _ in
            let sureAlert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "NO"), style: .`default`, handler: { _ in
                
            }))
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "YES"), style: .`default`, handler: { _ in
                AdminModel.currentUser!.userType = UserType.general
                self.userTypeLabel.text = UserType.general.rawValue
                AdminModel.saveUser(user: AdminModel.currentUser!)
            }))
            self.present(sureAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Admin", comment: "admin"), style: .`default`, handler: { _ in
            let sureAlert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "NO"), style: .`default`, handler: { _ in
                
            }))
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "YES"), style: .`default`, handler: { _ in
                AdminModel.currentUser!.userType = UserType.admin
                self.userTypeLabel.text = UserType.admin.rawValue
                AdminModel.saveUser(user: AdminModel.currentUser!)
            }))
            self.present(sureAlert, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Shelter Employee", comment: "shelter employee"), style: .`default`, handler: { _ in
            let sureAlert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "NO"), style: .`default`, handler: { _ in
                
            }))
            sureAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "YES"), style: .`default`, handler: { _ in
                AdminModel.currentUser!.userType = UserType.shelterEmpoyee
                self.userTypeLabel.text = UserType.shelterEmpoyee.rawValue
                AdminModel.saveUser(user: AdminModel.currentUser!)
            }))
            self.present(sureAlert, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unlockButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "NO"), style: .`default`, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "YES"), style: .`default`, handler: { _ in
            self.lockedLabel.text = "False"
            self.unlockButton.isHidden = true
            self.lockButton.isHidden = false
            AdminModel.unlockUser(user: AdminModel.currentUser!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func lockButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "NO"), style: .`default`, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "YES"), style: .`default`, handler: { _ in
            self.lockedLabel.text = "True"
            self.unlockButton.isHidden = false
            self.lockButton.isHidden = true
            AdminModel.lockUser(user: AdminModel.currentUser!)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
