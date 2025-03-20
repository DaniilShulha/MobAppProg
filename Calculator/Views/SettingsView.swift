//
//  ContentView.swift
//  Calculator
//
//  Created by znexie on 18.03.25.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var themeViewModel: ThemeViewModel
    @State private var localThemeColor: String = "#FFFFFF"
    
    var body: some View {
        ZStack {
            Color(hex: themeViewModel.selectedThemeColor)
                .ignoresSafeArea()
                .onChange(of: themeViewModel.selectedThemeColor) { newValue in
                    print("Settings Screen: цвет изменился на \(newValue)")
                }
            
            VStack(spacing: 20) {
                Text("Select Theme Color")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if themeViewModel.availableColors.isEmpty {
                    Text("Загрузка цветов...")
                        .foregroundColor(.white)
                } else {
                    Picker("Theme Color", selection: $localThemeColor) {
                        ForEach(themeViewModel.availableColors, id: \.self) { colorHex in
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: colorHex))
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                Text(colorHex)
                                    .foregroundColor(.white)
                            }
                            .tag(colorHex)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.white)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    themeViewModel.saveData(themeColor: localThemeColor)
                }) {
                    Text("Save Color")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            localThemeColor = themeViewModel.selectedThemeColor
        }
        .onChange(of: themeViewModel.selectedThemeColor) { newValue in
            localThemeColor = newValue
        }
    }
}

// Предпросмотр
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(themeViewModel: ThemeViewModel())
    }
}
