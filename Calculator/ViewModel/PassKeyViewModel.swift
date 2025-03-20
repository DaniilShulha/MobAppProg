// PassKeyViewModel.swift
import SwiftUI

class PassKeyViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var showResetPrompt = false
    
    private let keychainManager = KeychainManager()
    private let biometricManager = BiometricManager()
    
    init() {
        if keychainManager.getPassKey() != nil && biometricManager.canUseBiometrics() {
            authenticateWithBiometrics()
        }
    }
    
    // Проверка, установлен ли Pass Key
    var isPassKeySet: Bool {
        keychainManager.getPassKey() != nil
    }
    
    // Проверка доступности биометрии
    func canUseBiometrics() -> Bool {
        biometricManager.canUseBiometrics()
    }
    
    // Инициализация нового Pass Key
    func setPassKey(_ passKey: String) {
        if keychainManager.savePassKey(passKey) {
            isAuthenticated = true
            errorMessage = nil
            showResetPrompt = false
        } else {
            errorMessage = "Не удалось сохранить Pass Key"
        }
    }
    
    // Валидация Pass Key
    func validatePassKey(_ enteredPassKey: String) {
        guard let storedPassKey = keychainManager.getPassKey() else {
            errorMessage = "Pass Key не установлен"
            return
        }
        if storedPassKey == enteredPassKey {
            isAuthenticated = true
            errorMessage = nil
            showResetPrompt = false
        } else {
            errorMessage = "Неверный Pass Key"
            showResetPrompt = true
        }
    }
    
    // Аутентификация через биометрию
    func authenticateWithBiometrics() {
        biometricManager.authenticate { success, error in
            if success {
                self.isAuthenticated = true
                self.errorMessage = nil
                self.showResetPrompt = false
            } else {
                self.errorMessage = "Ошибка биометрии: \(error?.localizedDescription ?? "Неизвестная ошибка")"
                self.showResetPrompt = true
            }
        }
    }
    
    // Сброс Pass Key
    func resetPassKey() { // Убираем параметр newPassKey
        if keychainManager.deletePassKey() {
            isAuthenticated = false // Сбрасываем аутентификацию
            errorMessage = nil // Очищаем ошибку
            showResetPrompt = false // Скрываем кнопку сброса
        } else {
            errorMessage = "Не удалось сбросить Pass Key"
        }
    }
}
