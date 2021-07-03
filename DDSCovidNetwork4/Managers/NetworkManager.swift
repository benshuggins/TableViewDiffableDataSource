//
//  NetworkManager.swift
//  DDSCovidNetwork4
//
//  Created by Ben Huggins on 6/23/21.
//
//
//  NetworkManager.swift
//  DashCovid
//
//  Created by Ben Huggins on 5/12/21.
//"https://api.covid19api.com/countries"

// Webiste API:
//https://covid19api.com/

//Whats returned from above website
//[
//    {
//        "Country": "Republic of Kosovo",
//        "Slug": "kosovo",
//        "ISO2": "XK"
//    },
//    {
//        "Country": "Uruguay",
//        "Slug": "uruguay",
//        "ISO2": "UY"
//    },


// this is perfect for diffable data source

import Foundation
import UIKit

class  NetworkManager {

    static let shared = NetworkManager()
    let baseURl = "https://api.covid19api.com"
    
    private init() {}
    
    // completion handler inputs nothing
    func getCountries(completed: @escaping (Result<[Country], BHError>) -> Void) {
        let endpoint = baseURl + "/countries"
        
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse)) // this is used to send error back to VC that called it to inform it
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
             
            if let _ = error {
                completed(.failure(.invalidUsername))
                return
            }
                                        // if code is not nil, check status code of response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                
                completed(.failure(.unableToComplete))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let countries = try? decoder.decode([Country].self, from: data)
                completed(.success(countries!)) // finally data is good return countries for data and nil for the error
                
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()      //
    }
}


// Things to add:

// Cache network data for a search bar ??

// Right now network manager call has a strong reference to self or the SummaryVC
// need to add [weak self] in network closure


// Full programmatic version of this with a collectionView

// go diffable datasource

// Compositional layout eveentually  -- does compositional Layout work best with DDS?



