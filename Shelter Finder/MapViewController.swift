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
    
    var locationItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        
        searchBar.delegate = self
        searchBar.text = SearchCriteria.search
        
        if let location = Model.location {
            let initialLocation = CLLocation(latitude: location[0], longitude: location[1])
            centerMapOnLocation(location: initialLocation)
            locationItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location[0], longitude: location[1])))
            mapView.showsUserLocation = true
            //locationItem!.isCurrentLocation = true
            //mapView.addAnnotation(locationItem!)
        } else {
            let initialLocation = CLLocation(latitude: 33.774875, longitude: -84.397222)
            centerMapOnLocation(location: initialLocation)
        }
        var index = 0
        while index < Model.numberOfSearchedShelters() {
            mapView.addAnnotation(Model.getSearchedShelter(index: index))
            index += 1
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
        var index = 0
        while index < Model.numberOfSearchedShelters() {
            mapView.addAnnotation(Model.getSearchedShelter(index: index))
            index += 1
        }
    }
    
    @IBAction func advancedSearchPressed(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchView") as! AdvancedSearchViewController
        next.lastView = AdvancedSearchViewController.MAP_VIEW
        self.present(next, animated: true, completion: nil)
    }

}
