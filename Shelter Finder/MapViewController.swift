//
//  MapViewController.swift
//  Shelter Finder
//
//  Created by Berchenko, Amiel D on 4/5/18.
//  Copyright © 2018 Berchenko, Amiel D. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    
    // MARK : Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let regionRadius: CLLocationDistance = 20000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        searchBar.text = SearchCriteria.search
        
        let initialLocation = CLLocation(latitude: Model.location![0], longitude: Model.location![1])
        centerMapOnLocation(location: initialLocation)
        for index in 0...(Model.numberOfSearchedShelters() - 1) {
            mapView.addAnnotation(Model.getSearchedShelter(index: index))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK : Actions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchCriteria.search = searchText
        mapView.removeAnnotations(mapView.annotations)
        for index in 0...(Model.numberOfSearchedShelters() - 1) {
            mapView.addAnnotation(Model.getSearchedShelter(index: index))
        }
    }
    
    @IBAction func advancedSearchPressed(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchView") as! AdvancedSearchViewController
        next.lastView = AdvancedSearchViewController.MAP_VIEW
        self.present(next, animated: true, completion: nil)
    }

}
