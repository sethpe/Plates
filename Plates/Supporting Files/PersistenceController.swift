//
//  PersistenceController.swift
//  Plates
//
//  Created by Seth Petel on 2022-02-05.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        Helper.createDefaultWorkouts()
        
        return controller
    }()
    
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "PlatesDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    

    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do  {
                try context.save()
            } catch {
                // throw some error
            }
        }
    }
    
    
}
