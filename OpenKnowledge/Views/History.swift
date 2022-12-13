//
//  History.swift
//  OpenKnowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import SwiftUI

struct History: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var showAlert : Bool = false


    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack{
                            Text("Item at \(item.date!, formatter: itemFormatter)")
                            Text(item.text!)
                        }
                    } label: {
                        Text(item.text!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Label("Delete All", systemImage: "trash")
                    })
                    .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete all your entries?"),
                                message: Text("Clicking 'Yes' will permanently delete all entries"),
                                primaryButton: .default(
                                          Text("Cancel")
                                      ),
                                
                                  secondaryButton: .destructive(
                                      Text("Delete all entries"),
                                      action: {
                                          
                                          
                                      }
                                  )
                            )
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}