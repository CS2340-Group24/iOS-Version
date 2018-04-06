//
//  ShelterListViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 3/27/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit

class ShelterListViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var shelterListTable: ShelterListTable!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shelterListTable.dataSource = shelterListTable
        shelterListTable.delegate = self
        searchBar.delegate = self
        searchBar.text = SearchCriteria.search
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchCriteria.search = searchText
        shelterListTable.reloadData()
    }
    
    /*func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchView") as! AdvancedSearchViewController
        self.present(next, animated: true, completion: nil)
    }*/
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("Click")
        Model.currentShelter = Model.getSearchedShelter(index: indexPath.row)
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShelterView") as! ShelterViewController
        self.present(next, animated: true, completion: nil)
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
    
    @IBAction func advancedSearchPressed(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchView") as! AdvancedSearchViewController
        next.lastView = AdvancedSearchViewController.SHELTER_LIST
        self.present(next, animated: true, completion: nil)
    }

}
