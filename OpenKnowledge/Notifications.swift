//Received from minders app Prof provided
import Foundation
import SwiftUI

class NotificationMgr: ObservableObject {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if !success && error == nil {
                print("Notifications not permitted")
            }
        }
    }
    
    func scheduleNotification(title: String, notes: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = notes
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "Minder Notification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request)
    }
}
