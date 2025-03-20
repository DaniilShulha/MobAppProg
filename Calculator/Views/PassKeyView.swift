// PassKeyView.swift
import SwiftUI

struct PassKeyView: View {
    @ObservedObject var viewModel: PassKeyViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @State private var enteredPassKey = ""
    @State private var confirmPassKey = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.isPassKeySet ? "Введите Pass Key" : "Создайте Pass Key")
                .font(.headline)
                .foregroundColor(.white)
            
            SecureField("Pass Key", text: $enteredPassKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if !viewModel.isPassKeySet {
                SecureField("Подтвердите Pass Key", text: $confirmPassKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Подтвердить") {
                if viewModel.isPassKeySet {
                    viewModel.validatePassKey(enteredPassKey)
                } else if enteredPassKey == confirmPassKey && !enteredPassKey.isEmpty {
                    viewModel.setPassKey(enteredPassKey)
                } else {
                    viewModel.errorMessage = "Pass Key не совпадают или пустые"
                }
                if viewModel.isAuthenticated {
                    enteredPassKey = ""
                    confirmPassKey = ""
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            if viewModel.showResetPrompt {
                Button("Сбросить Pass Key") {
                    viewModel.resetPassKey() // Просто сбрасываем Pass Key
                    enteredPassKey = ""
                    confirmPassKey = ""
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            if viewModel.isPassKeySet && viewModel.canUseBiometrics() {
                Button("Использовать биометрию") {
                    viewModel.authenticateWithBiometrics()
                    if viewModel.isAuthenticated {
                        enteredPassKey = ""
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    PassKeyView(viewModel: PassKeyViewModel())
        .environmentObject(ThemeViewModel())
}
