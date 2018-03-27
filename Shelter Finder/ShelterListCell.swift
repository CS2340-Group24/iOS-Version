//
//  ShelterListCell.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class ShelterListCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var shelterLabel: UILabel!
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
