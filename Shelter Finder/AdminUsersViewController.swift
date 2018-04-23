//
//  AdminUsersViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/22/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class AdminUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK : Properties
    
    @IBOutlet weak var userListTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userListTable.dataSource = self
        userListTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdminModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminUsersCell", for: indexPath) as! AdminUsersCell
        
        let user = AdminModel.getUser(index: indexPath.row)
        cell.usernameLabel.text = user.username
        cell.userTypeLabel.text = user.userType.rawValue
        if user.banned {
            if let _ = user.newPassword {
                cell.bannedLabel.text = "Banned - Requested Access"
            } else {
                cell.bannedLabel.text = "Banned"
            }
        } else {
            cell.bannedLabel.text = ""
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        AdminModel.currentUser = AdminModel.getUser(index: indexPath.row)
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdminDetailedUserView") as! AdminDetailedUserViewController
        self.present(next, animated: true, completion: nil)
    }

}
