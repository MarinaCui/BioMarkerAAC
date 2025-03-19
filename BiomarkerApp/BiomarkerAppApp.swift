//
//  BiomarkerAppApp.swift
//  BiomarkerApp
//
//  Created by 崔弘一铭 on 2/20/25.
//

import SwiftUI

@main
struct BiomarkerAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //NotesListView()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
