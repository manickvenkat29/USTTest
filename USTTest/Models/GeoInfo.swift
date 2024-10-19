//
//  GeoInfo.swift
//  USTTest
//
//  Created by Manickam on 19/10/24.
//

import Foundation

struct GeoInfo: Codable {
    let ip: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let carrier: String?
    
    var location: String {
        return "\(city), \(region), \(country)"
    }
    
    var organization: String {
        return org
    }
    
}
