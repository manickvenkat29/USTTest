//
//  CoreDataManager.swift
//  USTTest
//
//  Created by Manickam on 18/10/24.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "USTTest")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load Core Data stack: \(error)")
                }
            }
            return container
        }()
    
    var context: NSManagedObjectContext {
        return persistContainer.viewContext
    }
    
    private func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Failed to save CoreData context: \(error)")
                }
            }
        }
    
    
    func saveDevice(name: String, ipAddress: String, status: String){
        let device = DeviceInfo(context: context)
        device.name = name
        device.ipAddress = ipAddress
        device.status = status
        
        saveContext()
    }
    
    
    func fetchDevices() -> [DeviceInfo] {
        let context = persistContainer.viewContext
        let fetchRequest: NSFetchRequest<DeviceInfo> = DeviceInfo.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch devices: \(error)")
            return []
        }
    }
    
    func updateDeviceStatus(ipAddress: String, status: String){
        let fetchRequest: NSFetchRequest<DeviceInfo> = DeviceInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ipAddress == %@", ipAddress)
        
        do {
            let devices = try context.fetch(fetchRequest)
            if let device = devices.first {
                device.status = status
                saveContext()
            }
        } catch {
            print("Failed to update device status: \(error)")
        }
    }
}
