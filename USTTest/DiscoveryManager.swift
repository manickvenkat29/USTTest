//
//  DiscoveryManager.swift
//  USTTest
//
//  Created by Manickam on 18/10/24.
//

import Foundation
import CoreData

struct Device {
    let name: String
    let ipAddress: String
    let status: String
}

class DeviceDiscoveryManager: NSObject, NetServiceBrowserDelegate, NetServiceDelegate{
    private var netServiceBrowser: NetServiceBrowser!
    private var discoveredDevices: [NetService] = []
    var onDeviceDiscovered: ((Device) -> Void)?
    
    func startDiscovery(){
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser.delegate = self
        netServiceBrowser.searchForServices(ofType: "_airplay.tcp", inDomain: "")
        print("startDiscovery")
    }
    
    func stopDiscovery(){
        netServiceBrowser.stop()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Found service: \(service.name)")

        discoveredDevices.append(service)
        service.delegate = self
        service.resolve(withTimeout: 10.0)
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addressData = sender.addresses?.first else { return }
        print(addressData);
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        
        // Convert 'addressData' to Data if needed
        let addressDataT = addressData as Data
        
        // Use withUnsafeBytes to get a pointer to the underlying bytes
        addressDataT.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) in
            let unsafePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: sockaddr.self)
            
            let result = getnameinfo(
                unsafePointer,
                socklen_t(addressDataT.count),
                &hostname,
                socklen_t(hostname.count),
                nil,
                0,
                NI_NUMERICHOST
            )
            
            if result == 0, let ipAddress = String(validatingUTF8: hostname) {
                let device = Device(name: sender.name, ipAddress: ipAddress, status: "Reachable")
                CoreDataManager.shared.saveDevice(name: sender.name, ipAddress: ipAddress, status: "Reachable")
                onDeviceDiscovered?(device)
            }
        }
        
        
    }
}
