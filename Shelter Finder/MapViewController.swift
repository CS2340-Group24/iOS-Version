//
//  MapViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/5/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : Actions
    
    @IBAction func advancedSearchPressed(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchView") as! AdvancedSearchViewController
        next.lastView = AdvancedSearchViewController.MAP_VIEW
        self.present(next, animated: true, completion: nil)
    }

}
