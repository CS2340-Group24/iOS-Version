//
//  EditReservationViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/5/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class EditReservationViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var reservationsLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    static let HOME_VIEW = 0
    static let SHELTER_VIEW = 1
    
    var lastView = EditReservationViewController.HOME_VIEW {
        didSet {
            if !(lastView == EditReservationViewController.HOME_VIEW || lastView == EditReservationViewController.SHELTER_VIEW) {
                lastView = EditReservationViewController.HOME_VIEW
            }
        }
    }
    
    private var originalSpots: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let _ = Model.user!.reservation {
            navigationTitle.title = "Edit Reservation"
        } else {
            navigationTitle.title = "Create Reservation"
        }
        nameLabel.text = Model.currentShelter!.name
        availableLabel.text = "Current available: \(Model.currentShelter!.currentAvailable)"
        
        stepper.isContinuous = false
        stepper.autorepeat = false
        stepper.minimumValue = 0
        stepper.maximumValue = 5
        stepper.stepValue = 1
        if let reservation = Model.user!.reservation {
            stepper.value = Double(reservation.beds)
            originalSpots = reservation.beds
        } else {
            stepper.value = 0
            originalSpots = 0
        }
        
        reservationsLabel.text = "Spots reserved: \(Int(stepper.value))"
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
    
    // MARK : Actions
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        Model.reserve(newSpots: Int(stepper.value))
        if lastView == EditReservationViewController.HOME_VIEW {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
            self.present(next, animated: true, completion: nil)
        } else if lastView == EditReservationViewController.SHELTER_VIEW {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ShelterView") as! ShelterViewController
            self.present(next, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if lastView == EditReservationViewController.HOME_VIEW {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
            self.present(next, animated: true, completion: nil)
        } else if lastView == EditReservationViewController.SHELTER_VIEW {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ShelterView") as! ShelterViewController
            self.present(next, animated: true, completion: nil)
        }
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        let available = Model.currentShelter!.currentAvailable + originalSpots - Int(stepper.value)
        if available < 0 {
            stepper.value -= 1
        } else if available > Model.currentShelter!.numericCapacity {
            stepper.value += 1
        } else {
            reservationsLabel.text = "Spots reserved: \(Int(stepper.value))"
            availableLabel.text = "Current available: \(available)"
        }
    }

}
