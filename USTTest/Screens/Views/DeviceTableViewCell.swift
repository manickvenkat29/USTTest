//
//  DeviceTableViewCell.swift
//  USTTest
//
//  Created by Manickam on 19/10/24.
//

import Foundation
import UIKit

class DeviceTableViewCell: UITableViewCell {
    
    // Outlets for custom views
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(with device: Device) {
        deviceNameLabel.text = device.name
        ipAddressLabel.text = device.ipAddress
        statusLabel.text = device.status
        
        if device.status == "Reachable" {
            statusLabel.textColor = .green
            statusIcon.image = UIImage(systemName: "checkmark.circle")
        } else {
            statusLabel.textColor = .red
            statusIcon.image = UIImage(systemName: "xmark.circle")
        }
    }
}
