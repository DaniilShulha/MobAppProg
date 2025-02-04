//
//  File.swift
//  Calculator
//
//  Created by znexie on 1.02.25.
//

import Foundation
import UIKit
class AppDelegate: UIResponder, ObservableObject, UIApplicationDelegate {

  @Published var isPotrait = true

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    
    return true
  }
  
  @objc func rotated() {
    self.isPotrait = UIDevice.current.orientation.isPortrait
    print("isPortrait = \(isPotrait)")
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
}
