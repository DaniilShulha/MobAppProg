//
//  MainView.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

//
//  MainView.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject var themeViewModel = ThemeViewModel()
    @StateObject var viewModel = ViewModel()
    @StateObject var passKeyViewModel = PassKeyViewModel()

    
    var body: some View {
        
        
        if !passKeyViewModel.isAuthenticated {
            PassKeyView(viewModel: passKeyViewModel)
        } else {
            TabView {
                CalcView()
                    .tabItem {
                        Label("Calculator", systemImage: "pencil.and.scribble")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "list.clipboard")
                    }
                NotificationView()
                    .tabItem {
                        Label("Notifications", systemImage: "bell")
                    }
            }
            .tint(Color.black)
            .environmentObject(themeViewModel)
            .environmentObject(viewModel)
        }
    }
}


#Preview {
    MainView()
        .environmentObject(ViewModel())
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1)
    }
}

import AVFoundation

struct CalcView: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Color(hex: themeViewModel.selectedThemeColor)
                    .ignoresSafeArea()
                    .onChange(of: themeViewModel.selectedThemeColor) { newValue in
                        print("CalcView: цвет изменился на \(newValue)")
                    }
                
                if geometry.size.width < 400 {
                    VStack(spacing: 12) {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(viewModel.value)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 52))
                                .padding(.horizontal, 30)
                                .gesture(DragGesture(minimumDistance: 10)
                                    .onEnded { gesture in
                                        if gesture.translation.width < 0 {
                                            viewModel.deleteLastDigit()
                                        }
                                    }
                                )
                        }
                        
                        ForEach(viewModel.buttonsArray, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { item in
                                    Button {
                                        viewModel.didTap(item: item)
                                        viewModel.isClicked.toggle()
                                        if viewModel.value == "Ошибка" {
                                            toogleTorch(on: true)
                                        } else {
                                            toogleTorch(on: false)
                                        }
                                    } label: {
                                        Text("\(item.rawValue)")
                                            .frame(width: viewModel.buttonWidth(item: item), height: viewModel.buttonHeight(item: item))
                                            .font(.system(size: 36))
                                            .fontWeight(.bold)
                                            .foregroundStyle(item.buttonFontColor)
                                            .background(item.buttonColor)
                                            .cornerRadius(15)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(viewModel.value)
                                .offset(CGSize(width: -200.0, height: 10.0))
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 52))
                                .padding(.horizontal, 30)
                                .gesture(DragGesture(minimumDistance: 10)
                                    .onEnded { gesture in
                                        if gesture.translation.width < 0 {
                                            viewModel.deleteLastDigit()
                                        }
                                    }
                                )
                        }
                        
                        ForEach(viewModel.buttonsArray, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { item in
                                    Button {
                                        viewModel.didTap(item: item)
                                        viewModel.isClicked.toggle()
                                        if viewModel.value == "Ошибка" {
                                            toogleTorch(on: true)
                                        } else {
                                            toogleTorch(on: false)
                                        }
                                    } label: {
                                        Text("\(item.rawValue)")
                                            .frame(width: viewModel.buttonWidth(item: item)/3, height: viewModel.buttonHeight(item: item)/5)
                                            .font(.system(size: 24))
                                            .fontWeight(.bold)
                                            .foregroundStyle(item.buttonFontColor)
                                            .background(item.buttonColor)
                                            .cornerRadius(15)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 32))
                            .padding(10)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showSettings) {
            SettingsScreen(themeViewModel: themeViewModel)
        }
    }
}



func toogleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }
    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }
}


