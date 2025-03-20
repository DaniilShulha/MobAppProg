//
//  HistoryView.swift
//  Calculator
//
//  Created by znexie on 12.03.25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var model = HistoryViewModel()
    @EnvironmentObject var themeViewModel: ThemeViewModel
    
    var body: some View {
        ZStack {
            Color(hex: themeViewModel.selectedThemeColor)
                .ignoresSafeArea()
            
            List(model.list) { item in
                HStack {
                    Text("Operation: \(item.operation)")
                    Spacer()
                    Text("Result: \(item.result)")
                }
                
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    init() {
        model.getData()
    }
}

#Preview {
    HistoryView()
}
