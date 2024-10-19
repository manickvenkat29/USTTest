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
        netServiceBrowser.searchForServices(ofType: "_airplay._tcp.", inDomain: "")
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
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        addressData.withUnsafeBytes { (rawBufferPointer: UnsafeRawBufferPointer) in
            let unsafePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: sockaddr.self)
            let result = getnameinfo(
                unsafePointer,
                socklen_t(addressData.count),
                &hostname,
                socklen_t(hostname.count),
                nil,
                0,
                NI_NUMERICHOST
            )
            
            if result == 0, let ipAddress = String(validatingUTF8: hostname) {
                // Check reachability
                let oAuthManager = OAuthLoginManager()

                oAuthManager.checkNetworkReachability { status in
                    if status {
                        let deviceStatus = (status != false) ? "Reachable" : "Un-Reachable"
                        CoreDataManager.shared.updateDeviceStatus(ipAddress: ipAddress, status: deviceStatus)
                        
                        let device = Device(name: sender.name, ipAddress: ipAddress, status: deviceStatus)
                        self.onDeviceDiscovered?(device)
                    } else {
                        print("Network is not reachable")
                    }
                }
            }
        }
    }
        
}
