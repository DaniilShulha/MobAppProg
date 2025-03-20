//
//  HistoryViewModel.swift
//  Calculator
//
//  Created by znexie on 12.03.25.
//
//
//import Foundation
//import FirebaseFirestore
//
//class HistoryViewModel: ObservableObject {
//    @Published var list = [History]()
//    
//    private let db = Firestore.firestore()
//    private var listener: ListenerRegistration?
//    
//    init() {
//        getData()
//    }
//    
//    func addData(operation: String, result: String) {
//        db.collection("history").addDocument(data: [
//            "operation": operation,
//            "result": result,
//        ]) { error in
//            if let error = error {
//                print("Ошибка добавления данных: \(error.localizedDescription)")
//            } else {
//                print("Данные успешно добавлены: \(operation) -> \(result)")
//            }
//        }
//    }
//    
//    func getData() {
//        listener = db.collection("history")
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Ошибка получения данных: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let snapshot = snapshot else {
//                    print("Снимок данных пуст")
//                    return
//                }
//                
//                print("Получено \(snapshot.documents.count) документов")
//                
//                DispatchQueue.main.async {
//                    self.list = snapshot.documents.map { d in
//                        return History(id: d.documentID,
//                                     operation: d["operation"] as? String ?? "",
//                                     result: d["result"] as? String ?? "")
//                    }
//                    print("Обновлен список: \(self.list)")
//                }
//            }
//    }
//    
//    deinit {
//        listener?.remove()
//    }
//}

import Foundation
import FirebaseFirestore

class HistoryViewModel: ObservableObject {
    @Published var list = [History]()
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        getData()
    }
    
    func addData(operation: String, result: String) {
        db.collection("history").addDocument(data: [
            "operation": operation,
            "result": result,
            "timestamp": FieldValue.serverTimestamp() // Добавляем серверную временную метку
        ]) { error in
            if let error = error {
                print("Ошибка добавления данных: \(error.localizedDescription)")
            } else {
                print("Данные успешно добавлены: \(operation) -> \(result)")
            }
        }
    }
    
    func getData() {
        listener = db.collection("history")
            .order(by: "timestamp", descending: true) // Сортировка по убыванию времени
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Ошибка получения данных: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Снимок данных пуст")
                    return
                }
                
                print("Получено \(snapshot.documents.count) документов")
                
                DispatchQueue.main.async {
                    self.list = snapshot.documents.map { d in
                        return History(
                            id: d.documentID,
                            operation: d["operation"] as? String ?? "",
                            result: d["result"] as? String ?? "",
                            timestamp: (d["timestamp"] as? Timestamp)?.dateValue() // Получаем дату
                        )
                    }
                    print("Обновлен список: \(self.list)")
                }
            }
    }
    
    deinit {
        listener?.remove()
    }
}
