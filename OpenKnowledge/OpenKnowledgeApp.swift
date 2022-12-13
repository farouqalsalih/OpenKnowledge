//
//  OpenKnowledgeApp.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import SwiftUI

@main
struct OpenKnowledgeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
