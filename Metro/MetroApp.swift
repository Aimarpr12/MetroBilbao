//
//  MetroApp.swift
//  Metro
//
//  Created by Aimar Pelea on 11/3/24.
//

import SwiftUI

@main
struct MetroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
