//
//  PlatesApp.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import SwiftUI

@main
struct PlatesApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase){ _ in
            persistenceController.save()
        }
    }
}
