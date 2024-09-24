//
//  ViewController.swift
//  Map
//
//  Created by Rakesh Kumar on 24/09/24.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    private var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: ResultViewController())
        controller.searchBar.placeholder = "search places"
        controller.searchBar.barTintColor = .red
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.backgroundColor = .clear
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
}


extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultController = searchController.searchResultsController as? ResultViewController else {return}
        resultController.delegate = self
        GoogleManager.shared.findPlace(query: query) { result in
            switch result {
            case .success(let data):
                resultController.configure(with: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MapViewController:  ResultViewControllerDelegate{
    func ResultViewControllerDidTap(with coordinate: CLLocationCoordinate2D) {
        searchController.searchBar.resignFirstResponder()
        // remove pin
        let annotation = mapView.annotations
        mapView.removeAnnotations(annotation)
        
        //create pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)), animated: true)
    }
}

