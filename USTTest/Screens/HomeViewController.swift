//
//  HomeViewController.swift
//  USTTest
//
//  Created by Manickam on 18/10/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var deviceTableView: UITableView!
    var devicesList: [Device] = []
    var discoveryManager: DeviceDiscoveryManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        discoveryManager = DeviceDiscoveryManager()
        
        discoveryManager.onDeviceDiscovered = { [weak self] device in
            
            guard let self = self else { return }
            if let index = self.devicesList.firstIndex(where: { $0.ipAddress == device.ipAddress }) {
                self.devicesList[index] = device
            } else {
                self.devicesList.append(device)
            }
            
            DispatchQueue.main.async {
                self.deviceTableView.reloadData()
            }
        }
        discoveryManager.startDiscovery()
        loadDevicesFromCoreData()
        
    }
    
    func loadDevicesFromCoreData() {
        let coreDataDevices = CoreDataManager.shared.fetchDevices()
        for deviceInfo in coreDataDevices {
            if let name = deviceInfo.name, let ipAddress = deviceInfo.ipAddress, !deviceInfo.isDeleted {
                if !devicesList.contains(where: { $0.ipAddress == ipAddress }) {
                    let device = Device(name: name, ipAddress: ipAddress, status: deviceInfo.status ?? "Unknown")
                    devicesList.append(device)
                }
            }
        }
        deviceTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DeviceTableViewCell else {
               return UITableViewCell()
           }

        let device = devicesList[indexPath.row]
        cell.configure(with: device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDevice = devicesList[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: selectedDevice)
    }
    
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGroupedBackground
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Discovered AirPlay Devices (\(devicesList.count))"
         
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.text = "Tap on a device to view details"
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
                        subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0 // Adjust height as needed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails", let destinationVC = segue.destination as? DetailViewController, let selectedDevice = sender as? Device {
            destinationVC.selectedDevice = selectedDevice
        }
    }
    

}
