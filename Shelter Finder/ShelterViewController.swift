//
//  ShelterViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/30/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class ShelterViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //@IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var reservationsLabel: UILabel!
    @IBOutlet weak var editReservationsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = Model.currentShelter!.name
        descriptionLabel.text = Model.currentShelter!.notes
        restrictionsLabel.text = "Restrictions: \(Model.currentShelter!.restrictions)"
        //addressButton.setTitle(Model.currentShelter!.address, for: .normal)
        addressLabel.text = Model.currentShelter!.address
        phoneLabel.text = Model.currentShelter!.phone
        capacityLabel.text = "Current capacity: \(Model.currentShelter!.currentAvailable)"
        var isReserved = false
        if let reservation = Model.user!.reservation {
            if reservation.shelter!.key == Model.currentShelter!.key {
                isReserved = true
                reservationsLabel.text = "Spots reserved: \(reservation.beds)"
                editReservationsButton.setTitle("Edit reservation", for: .normal)
            }
        }
        if !isReserved {
            reservationsLabel.text = "No reservation yet"
            editReservationsButton.setTitle("Create reservation", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    
    @IBAction func editReservations(_ sender: Any) {
    }
    

}
