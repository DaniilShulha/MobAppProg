//
//  CalculatorApp.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CalculatorApp: App {
    private var delegate2: NotificationDelegate = NotificationDelegate()
    init() {
            let center = UNUserNotificationCenter.current()
            center.delegate = delegate2
            center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
                if let error = error {
                    print(error)
                }
            }
        }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
