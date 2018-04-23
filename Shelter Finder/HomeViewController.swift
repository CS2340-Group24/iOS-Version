//
//  HomeViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 2/20/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var reservationsLabel: UILabel!
    @IBOutlet weak var editReservationsButton: UIButton!
    @IBOutlet weak var specialtyBar: UINavigationBar!
    @IBOutlet weak var usersButton: UIBarButtonItem!
    @IBOutlet weak var sheltersButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SearchCriteria.reset()
        if let user = Model.user {
            if let reservation = user.reservation {
                let shelter = reservation.shelter
                titleLabel.text = shelter.name
                descriptionLabel.text = shelter.notes
                restrictionsLabel.text = shelter.restrictions
                addressLabel.text = shelter.address
                phoneLabel.text = shelter.phone
                capacityLabel.text = "Current capacity: \(shelter.currentAvailable)"
                reservationsLabel.text = "Spots reserved: \(reservation.beds)"
                editReservationsButton.setTitle("Edit reservations", for: .normal)
                Model.currentShelter = shelter
            } else {
                titleLabel.text = "No current reservation"
                descriptionLabel.text = ""
                restrictionsLabel.text = ""
                addressLabel.text = ""
                phoneLabel.text = ""
                capacityLabel.text = ""
                reservationsLabel.text = ""
                editReservationsButton.isHidden = true
            }
            
            if user.userType == UserType.general {
                specialtyBar.isHidden = true
            } else if user.userType == UserType.admin {
                specialtyBar.isHidden = false
                usersButton.title = "Edit Users"
                sheltersButton.title = "Edit Shelters"
            } else if user.userType == UserType.shelterEmpoyee {
                specialtyBar.isHidden = false
                usersButton.title = "View Reservations"
                sheltersButton.title = "View My Shelter"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Actions
    
    @IBAction func editReservationsPressed(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "EditReservationView") as! EditReservationViewController
        next.lastView = EditReservationViewController.HOME_VIEW
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func usersButtonPressed(_ sender: UIBarButtonItem) {
        if Model.user!.userType == UserType.admin {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AdminUsersView") as! AdminUsersViewController
            self.present(next, animated: true, completion: nil)
        } else if Model.user!.userType == UserType.shelterEmpoyee {
            
        }
    }
    
    @IBAction func sheltersButtonPressed(_ sender: UIBarButtonItem) {
        if Model.user!.userType == UserType.admin {
            
        } else if Model.user!.userType == UserType.shelterEmpoyee {
            
        }
    }
    
    
}
