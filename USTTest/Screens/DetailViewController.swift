//
//  DetailViewController.swift
//  USTTest
//
//  Created by Manickam on 19/10/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedDevice: Device?
    @IBOutlet weak var publicIPLabel: UILabel!
    @IBOutlet weak var geoInfoLabel: UILabel!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var postalLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPublicIP()
    }
    
    func fetchPublicIP() {
        NetworkManager.shared.getPublicIP { ip in
            DispatchQueue.main.async { [self] in
                self.publicIPLabel.text = "IP: \(ip)"
                self.fetchGeoInfo(for: ip)
            }
        }
    }

    func fetchGeoInfo(for ip: String) {
        NetworkManager.shared.getGeoInfo(for: ip) { geoInfo in
            DispatchQueue.main.async { [self] in
                self.geoInfoLabel.text = "Location: \(geoInfo.location)"
                self.carrierLabel.text = "Carrier: \(geoInfo.carrier ?? "N/A")"
                self.regionLabel.text = "Region: \(geoInfo.region)"
                self.countryLabel.text = "Country: \(geoInfo.country)"
                self.locLabel.text = "Location: \(geoInfo.loc)"
                self.orgLabel.text = "Org: \(geoInfo.org)"
                self.postalLabel.text = "Postal: \(geoInfo.postal)"
                self.timezoneLabel.text = "Timezone: \(geoInfo.timezone)"

        
                
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
