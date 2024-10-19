//
//  NetworkManager.swift
//  USTTest
//
//  Created by Manickam on 19/10/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func getPublicIP(completion: @escaping (String)-> Void) {
        let url = URL(string: "https://api.ipify.org?format=json")!
        URLSession.shared.dataTask(with: url) {
            data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dict = json as? [String: Any],
               let ip = dict["ip"] as? String {
                completion(ip)
            }
        }.resume()
    }
    
    
    func getGeoInfo(for ip: String, completion: @escaping (GeoInfo) -> Void) {
        let url = URL(string: "https://ipinfo.io/\(ip)/geo")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
               let dict = json as? [String: Any] {
                let geoInfo = GeoInfo(
                    ip:dict["ip"] as? String ?? "",
                    city: dict["city"] as? String ?? "",
                    region: dict["region"] as? String ?? "",
                    country: dict["country"] as? String ?? "",
                    loc: dict["loc"] as? String ?? "",
                    org: dict["org"] as? String ?? "",
                    postal: dict["postal"] as? String ?? "",
                    timezone: dict["timezone"] as? String ?? "",
                    carrier: dict["org"] as? String
                )
                
                DispatchQueue.main.async {
                    completion(geoInfo)
                }
            }
        }.resume()
    }
    
}
