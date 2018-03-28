//
//  ShelterListTable.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class ShelterListTable: UITableView, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.numberOfSearchedShelters()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterListCell", for: indexPath) as! ShelterListCell
        
        let shelter = Model.getSearchedShelter(index: indexPath.row)
        cell.shelterLabel.text = shelter.name
        cell.restrictionsLabel.text = shelter.notes
        if let distance = shelter.distance {
            cell.distanceLabel.text = "\(distance) miles away"
        } else {
            cell.distanceLabel.text = shelter.restrictions
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
