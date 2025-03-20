//
//  KeychainManager.swift
//  Calculator
//
//  Created by znexie on 19.03.25.
//

// KeychainManager.swift
import Foundation
import Security

class KeychainManager {
    private let service = "com.yourapp.passkey"
    private let account = "userPassKey"
    
    // Сохранение Pass Key
    func savePassKey(_ passKey: String) -> Bool {
        let data = Data(passKey.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked // Доступ только при разблокированном устройстве
        ]
        
        SecItemDelete(query as CFDictionary) // Удаляем старый ключ, если есть
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == noErr
    }
    
    // Получение Pass Key
    func getPassKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == noErr, let data = item as? Data else {
            print("Ошибка получения Pass Key: \(status)")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    // Удаление Pass Key
    func deletePassKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == noErr || status == errSecItemNotFound
    }
}
