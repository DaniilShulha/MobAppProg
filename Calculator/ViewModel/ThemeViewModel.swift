import Foundation
import FirebaseFirestore
import SwiftUI

class ThemeViewModel: ObservableObject {
    @Published var availableColors: [String] = []
    @Published var selectedThemeColor: String = "#FFFFFF"
    
    private let db = Firestore.firestore()
    
    init() {
        getData()
    }
    
    func getData() {
        db.collection("settings").document("theme").getDocument { document, error in
            if let error = error {
                print("Ошибка получения данных: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                let data = document.data() ?? [:]
                DispatchQueue.main.async {
                    self.availableColors = data["availableColors"] as? [String] ?? ["#FF0000", "#00FF00", "#0000FF", "#FFFFFF", "#000000"]
                    self.selectedThemeColor = data["selectedThemeColor"] as? String ?? "#FFFFFF"
                    print("Данные загружены: availableColors = \(self.availableColors), themeColor = \(self.selectedThemeColor)")
                }
            } else {
                print("Документ не найден, используются значения по умолчанию")
                DispatchQueue.main.async {
                    self.availableColors = ["#FF0000", "#00FF00", "#0000FF", "#FFFFFF", "#000000"]
                    self.selectedThemeColor = "#FFFFFF"
                }
            }
        }
    }
    
    func saveData(themeColor: String) {
        // Явно уведомляем об изменении перед обновлением
        DispatchQueue.main.async {
            self.objectWillChange.send() // Уведомляем SwiftUI об изменении
            self.selectedThemeColor = themeColor
            print("Локально обновлён цвет: \(self.selectedThemeColor)")
        }
        
        // Сохраняем в Firestore
        let themeData: [String: Any] = [
            "availableColors": availableColors,
            "selectedThemeColor": themeColor
        ]
        
        db.collection("settings").document("theme").setData(themeData) { error in
            if let error = error {
                print("Ошибка сохранения: \(error.localizedDescription)")
            } else {
                print("Тема сохранена в Firestore: \(themeData)")
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 1; g = 1; b = 1
        }
        self.init(red: r, green: g, blue: b)
    }
}
