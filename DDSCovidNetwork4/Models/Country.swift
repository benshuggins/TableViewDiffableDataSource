//
//  Country.swift
//  DDSCovidNetwork4
//
//  Created by Ben Huggins on 6/23/21.
//
import Foundation


struct Country: Codable, Hashable {
    let name: String
    let iso: String
    
    enum CodingKeys: String, CodingKey {
            case name = "Country"
            case iso = "ISO2"      // ISO isn't unique enough
        }
    }
