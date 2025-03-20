//
//  NotificationView.swift
//  Calculator
//
//  Created by znexie on 18.03.25.
//

import Foundation
import SwiftUI
import UserNotifications

enum NotificationAction: String {
    case dimiss
    case reminder
}

enum NotificationCategory: String {
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

struct NotificationView: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel // Подключаем ThemeViewModel
    
    var body: some View {
        ZStack { // Заменяем VStack на ZStack для фона
            Color(hex: themeViewModel.selectedThemeColor) // Используем цвет из ThemeViewModel
                .ignoresSafeArea()
                
            
            VStack {
                Button {
                    let center = UNUserNotificationCenter.current()
                    
                    // create content
                    let content = UNMutableNotificationContent()
                    content.title = "Calculate Time!"
                    content.body = "Calculate something pls!"
                    content.categoryIdentifier = NotificationCategory.general.rawValue
                    content.userInfo = ["customData": "Some Data"]
                    
                    if let url = Bundle.main.url(forResource: "coffee", withExtension: "png") {
                        if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
                            content.attachments = [attachment]
                        }
                    }
                    
                    // create trigger
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
                    
                    // create request
                    let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
                    
                    // define actions
                    let dismiss = UNNotificationAction(identifier: NotificationAction.dimiss.rawValue, title: "Dismiss", options: [])
                    let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
                    let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismiss, reminder], intentIdentifiers: [], options: [])
                    
                    center.setNotificationCategories([generalCategory])
                    
                    // add request to notification center
                    center.add(request) { error in
                        if let error = error {
                            print(error)
                        }
                    }
                } label: {
                    HStack {
                        Text("Send notification")
                            .font(.title)
                        Image(systemName: "bell.badge.waveform")
                            .font(.system(size: 32))
                    }
                    .padding()
                    .foregroundColor(.pink)
                    .background(Color.black)
                    .cornerRadius(20)
                }
                .shadow(radius: 25)
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(ThemeViewModel()) // Для предпросмотра
    }
}
