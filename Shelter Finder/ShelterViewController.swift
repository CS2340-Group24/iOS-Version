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
        capacityLabel.text = "Current available: \(Model.currentShelter!.currentAvailable)"
        var isReserved = false
        if let reservation = Model.user!.reservation {
            if reservation.shelter.key == Model.currentShelter!.key {
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
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func editReservationPressed(_ sender: UIButton) {
        if let reservation = Model.user!.reservation {
            if reservation.shelter.key == Model.currentShelter!.key {
                let next = self.storyboard?.instantiateViewController(withIdentifier: "EditReservationView") as! EditReservationViewController
                next.lastView = EditReservationViewController.SHELTER_VIEW
                self.present(next, animated: true, completion: nil)
            } else {
                presentAlert(title: "Reservation with other shelter already exists", message: "Please remove this reservation before creating a new one")
            }
        } else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "EditReservationView") as! EditReservationViewController
            next.lastView = EditReservationViewController.SHELTER_VIEW
            self.present(next, animated: true, completion: nil)
        }
    }

}
