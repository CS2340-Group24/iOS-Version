//
//  ShelterListViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class ShelterListViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Properties
    @IBOutlet weak var shelterListTable: ShelterListTable!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SearchCriteria.reset()
        shelterListTable.dataSource = shelterListTable
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchCriteria.search = searchText
        shelterListTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
