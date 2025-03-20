//
//  BiometricManager.swift
//  Calculator
//
//  Created by znexie on 19.03.25.
//

// BiometricManager.swift
import LocalAuthentication

class BiometricManager {
    private let context = LAContext()
    
    func canUseBiometrics() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticate(completion: @escaping (Bool, Error?) -> Void) {
        let reason = "Подтвердите свою личность для доступа"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
