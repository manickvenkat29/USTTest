//
//  HomeViewController.swift
//  USTTest
//
//  Created by Manickam on 18/10/24.
//

import UIKit



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
               let device = devicesList[indexPath.row]
               cell.textLabel?.text = "\(device.name) - \(device.ipAddress)"
               cell.detailTextLabel?.text = device.status
               return cell
    }
    
    
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
            self?.devicesList.append(device)
            self?.deviceTableView.reloadData()
                }
        discoveryManager.startDiscovery()
        loadDevicesFromCoreData()
    }
    
    func loadDevicesFromCoreData() {
        // Fetch devices from CoreData
        let coreDataDevices = CoreDataManager.shared.fetchDevices()
        //devicesList = coreDataDevices
        print(devicesList);
        deviceTableView.reloadData()
        
        }
    

}
