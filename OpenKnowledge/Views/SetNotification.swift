//
//  SetNotification.swift
//  Open Knowledge
//
//  Created by Farouq Alsalih on 12/12/22.
//

import SwiftUI

struct SetNotification: View {
    @State private var dateSet = Date()
    @State private var AlertSheet = false
    @ObservedObject var notiMGR = NotificationMgr()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack{
            Text("Create a Notification Below:")
            DatePicker("When:", selection: $dateSet)
                .datePickerStyle(GraphicalDatePickerStyle())
            HStack {
                Button(action: {
                    AlertSheet = true
                }, label: {
                    Text("Set A Notification")
                })
                .alert(isPresented: $AlertSheet) {
                        Alert(title: Text("Setting a notification is irreversible. Are you sure?"),
                                    message: Text("Click Set Date to set the notification"),
                                   primaryButton: .destructive(
                                    Text("Set Notification"),
                                    action:{
                                        notiMGR.scheduleNotification(title: "Create a search Now!", notes: "Get smarter everyday!", date: dateSet)
                                        dismiss()

                                    }
                                   ),
                                   secondaryButton: .default (
                                        Text("Don't Set")
                                   )
                        )
                    }
            }
        }
    }
}


struct SetNotification_Previews: PreviewProvider {
    static var previews: some View {
        SetNotification()
    }
}
