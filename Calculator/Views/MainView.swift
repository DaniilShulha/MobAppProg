//
//  MainView.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ZStack {
            Color(.systemGray2)
                .ignoresSafeArea()
            
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
                                if gesture.translation.width < 0 { // Свайп влево
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
                            } label: {
                                Text("\(item.rawValue)")
                                    .frame(width: viewModel.buttonWidth(item: item), height: viewModel.buttonHeight(item: item))
                                    .font(.system(size: 36))
                                    .fontWeight(.bold)
                                    .foregroundStyle(item.buttonFontColor)
                                    .background(item.buttonColor)
                                    .cornerRadius(15)
                            }.buttonStyle(ScaleButtonStyle())
                        }
                    }
                }
            }
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
