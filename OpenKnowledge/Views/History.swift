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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var showSheet : Bool = false


    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ScrollView{
                            VStack{
                                Text("Date: \(item.date!, formatter: itemFormatter)")
                                Text("Response:")
                                Text(String(item.text!.filter{!"\n".contains($0)}))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Group{
                                    Text("Tokens Used Breakdown:")
                                    Text(item.completion!)
                                    Text(item.prompt_t!)
                                    Text(item.total!)
                                    Text("\nCreated ID:")
                                    Text(item.created!)
                                    Text("Response ID: \(item.id!)")
                                        .multilineTextAlignment(.center)
                                }

                                Button (action:{
                                    item.liked.toggle()
                                }, label: {
                                    Image(item.liked == true ? "liked" : "like")
                                }).scaleEffect(0.7)
                            }
                        }
                    } label: {
                        HStack{
                            Image(item.liked == true ? "liked" : "like").scaleEffect(0.4)
                            VStack{
                                Text(item.promptText ?? "Error")
                                Text(item.date!, formatter: itemFormatter)
                            }
                        }
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
                        showSheet = true
                    }, label: {
                        Label("Delete All", systemImage: "clock")
                    })
                }
            }.sheet(isPresented: $showSheet) {
                SetNotification()
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
