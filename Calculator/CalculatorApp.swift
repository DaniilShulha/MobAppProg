//
//  CalculatorApp.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

import SwiftUI

@main
struct CalculatorApp: App {
    @StateObject var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
}
