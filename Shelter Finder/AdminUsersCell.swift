//
//  AdminUsersCell.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/23/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class AdminUsersCell: UITableViewCell {
    
    // MARK : Properties
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var bannedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
