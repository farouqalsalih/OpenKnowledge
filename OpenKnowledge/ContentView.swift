//
//  ContentView.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var persistData = persist()


    var body: some View {
        TabView {
            Group{
                Compose()
                    .tabItem {
                        Label ("Compose", systemImage: "keyboard")
                    }
                    .environmentObject(persistData)
                
                History()
                    .tabItem {
                        Label("History", systemImage: "list.bullet.rectangle.portrait.fill")
                    }
                
                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .environmentObject(persistData)
                
                Info()
                    .tabItem {
                        Label("Info", systemImage: "questionmark.app.fill")
                    }
            }
            
            
            
        }.onAppear() {
            UITabBar.appearance().barTintColor = .systemBackground
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
