//
//  AdvancedSearchViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/29/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class AdvancedSearchViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var maleSwitch: UISwitch!
    @IBOutlet weak var femaleSwitch: UISwitch!
    @IBOutlet weak var familySwitch: UISwitch!
    @IBOutlet weak var childrenSwitch: UISwitch!
    @IBOutlet weak var youngAdultSwitch: UISwitch!
    @IBOutlet weak var veteranSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        maleSwitch.isOn = SearchCriteria.male
        femaleSwitch.isOn = SearchCriteria.female
        familySwitch.isOn = SearchCriteria.families
        childrenSwitch.isOn = SearchCriteria.children
        youngAdultSwitch.isOn = SearchCriteria.youngAdults
        veteranSwitch.isOn = SearchCriteria.veterans
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Actions
    
    @IBAction func maleSwitched(_ sender: UISwitch) {
        SearchCriteria.male = sender.isOn
    }
    
    @IBAction func femaleSwitched(_ sender: UISwitch) {
        SearchCriteria.female = sender.isOn
    }
    
    @IBAction func familySwitched(_ sender: UISwitch) {
        SearchCriteria.families = sender.isOn
    }
    
    @IBAction func childrenSwitched(_ sender: UISwitch) {
        SearchCriteria.children = sender.isOn
    }
    
    @IBAction func youngAdultsSwitched(_ sender: UISwitch) {
        SearchCriteria.youngAdults = sender.isOn
    }
    
    @IBAction func veteransSwitched(_ sender: UISwitch) {
        SearchCriteria.veterans = sender.isOn
    }

}
