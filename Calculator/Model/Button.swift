//
//  Button.swift
//  Calculator
//
//  Created by znexie on 31.01.25.
//

import Foundation
import SwiftUI

enum Buttons: String {
    case zero = "0", one = "1",
         two = "2", three = "3",
         four = "4", five = "5",
         six = "6", seven = "7",
         eight = "8", nine = "9"
    
    case plus = "+", minus = "-",
         multiple = "×", divide = "÷",
         equal = "=", decimal = ".",
         percent = "%", negative = "+/-",
         clear = "AC"
    
    case sin = "sin", cos = "cos",
         tg = "tan", ctg = "ctg",
         sqrt = "√"
    
    var buttonColor: Color {
        switch self {
        case .clear, .negative, .percent :
            return Color(.systemIndigo)
        case .divide, .multiple, .minus, .plus, .equal:
            return Color(.systemBrown)
        case .sin, .cos, .tg, .ctg:
            return .triganom
        default:
            return Color.gray
        }
    }
    
    var buttonFontColor: Color {
        switch self {
        case .clear, .negative, .percent :
            return Color.white
        case .divide, .multiple, .minus, .plus, .equal:
            return Color.black
        default:
            return Color.black
        }
    }
}
