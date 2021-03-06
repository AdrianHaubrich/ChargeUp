//
//  ChargeUpApp.swift
//  Shared
//
//  Created by Adrian Haubrich on 14.11.21.
//

import SwiftUI
import Firebase

@main
struct ChargeUpApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
