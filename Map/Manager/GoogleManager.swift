//
//  GoogleManager.swift
//  Map
//
//  Created by Rakesh Kumar on 24/09/24.
//


import Foundation
import GooglePlaces
import CoreLocation

enum APPErr: Error {
    case PlaceFindingError
    case LocationFindingError
}

class GoogleManager {
    static let shared = GoogleManager()
    var client = GMSPlacesClient.shared()
    
    func findPlace(query: String, completion: @escaping (Result<[Place], Error>)->()){
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { data, error in
            guard let data = data, error == nil else {
                completion(.failure(APPErr.PlaceFindingError))
                return
            }
            
            var place: [Place] = [Place]()
            
            for item in data {
                let placeArray = Place(place: item.attributedFullText.string, placeId: item.placeID)
                place.append(placeArray)
            }
            completion(.success(place))
        }
    }
    
    func resolveLocation(with place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> ()){
        client.fetchPlace(fromPlaceID: place.placeId, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(APPErr.LocationFindingError))
                return
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: googlePlace.coordinate.latitude, longitude: googlePlace.coordinate.longitude)
            completion(.success(coordinate))
        }
    }
}
