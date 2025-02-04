import Foundation
import UIKit

class ViewModel: ObservableObject {
    @Published var isClicked: Bool = false
    @Published var value: String = "0"
    @Published var number: Double = 0.0
    @Published var currentOperation: Operation = .none
    @Published var isResultDisplayed: Bool = false // ✅ Флаг для сброса ввода после "="
    
    let buttonsArray: [[Buttons]] = [
        [.sin, .cos, .tg, .ctg],
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiple],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .sqrt, .decimal, .equal]
    ]
    
    func buttonWidth(item: Buttons) -> CGFloat {
        let spacing: CGFloat = 12
        let totalSpacing: CGFloat = 5 * spacing
        let totalColumns: CGFloat = 4
        let screenWidth = UIScreen.main.bounds.width
        
        return (screenWidth - totalSpacing) / totalColumns
    }
    
    func buttonHeight(item: Buttons) -> CGFloat {
        return buttonWidth(item: item)
    }
    
    func didTap(item: Buttons) {
        
        switch item {
        case .plus, .minus, .multiple, .divide:
            number = Double(value) ?? 0
            currentOperation = operationForButton(item)
            value = "0"
        case .equal:
            if let currentValue = Double(value) {
                let result = performOperation(currentValue)
                value = result
                resetOperation()
                isResultDisplayed = true // ✅ Помечаем, что показан результат
            }
        case .decimal:
            if !value.contains(".") {
                value += "."
            }
        case .percent:
            if let currentValue = Double(value) {
                value = formatResult(currentValue / 100)
            }
        case .negative:
            if let currentValue = Double(value) {
                value = formatResult(-currentValue)
            }
        case .clear:
            resetAll()
        case .sin, .cos, .tg, .ctg, .sqrt:
            number = Double(value) ?? 0
            currentOperation = operationForButton(item)
            let result = performOperation(number)
            value = result
            resetOperation()
            isResultDisplayed = true
        default:
            if value == "0" || isResultDisplayed {
                value = item.rawValue
                isResultDisplayed = false
            } else {
                value += item.rawValue
            }
        }
    }
    
    func operationForButton(_ item: Buttons) -> Operation {
        switch item {
        case .plus: return .addition
        case .minus: return .subtract
        case .multiple: return .multiply
        case .divide: return .divide
        case .sin: return .sin
        case .cos: return .cos
        case .tg: return .tg
        case .ctg: return .ctg
        case .sqrt: return .sqrt
        default: return .none
        }
    }
    
    func performOperation(_ currentValue: Double) -> String {
        switch currentOperation {
        case .addition:
            return formatResult(number + currentValue)
        case .subtract:
            return formatResult(number - currentValue)
        case .multiply:
            return formatResult(number * currentValue)
        case .divide:
            return currentValue == 0 ? "Ошибка" : formatResult(number / currentValue)
        case .sin:
            return formatResult(sin(number))
        case .cos:
            return formatResult(cos(number))
        case .tg:
            return checkTgError(number) ? "Ошибка" : formatResult(tan(number))
        case .ctg:
            return checkCtgError(number) ? "Ошибка" : formatResult(1 / tan(number))
        case .sqrt:
            return number < 0 ? "Ошибка" : formatResult(sqrt(number))
        default:
            return formatResult(currentValue)
        }
    }
    
    func checkTgError(_ value: Double) -> Bool {
        let rad = value.truncatingRemainder(dividingBy: .pi)
        return abs(rad - (.pi / 2)) < 0.0001
    }

    func checkCtgError(_ value: Double) -> Bool {
        let rad = value.truncatingRemainder(dividingBy: .pi)
        return abs(rad) < 0.0001
    }
    
    func formatResult(_ result: Double) -> String {
        return String(format: "%g", result)
    }
    
    func deleteLastDigit() {
        if value.count > 1 {
            value.removeLast()
        } else {
            value = "0"
        }
    }
    
    func resetAll() {
        value = "0"
        number = 0.0
        currentOperation = .none
        isResultDisplayed = false
    }

    func resetOperation() {
        currentOperation = .none
        number = 0.0
    }
}
