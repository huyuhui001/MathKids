//
//  MathCategory.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import Foundation

enum OperationType: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "−"
    case multiplication = "×"
    case division = "÷"
    
    var id: String { rawValue }
}

enum DigitType: String, CaseIterable, Identifiable {
    case oneDigit = "1"
    case twoDigit = "2"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .oneDigit:
            return "1"
        case .twoDigit:
            return "2"
        }
    }
}

struct MathCategory: Identifiable, Hashable {
    let id = UUID()
    let operation: OperationType
    let digitType: DigitType
    
    var localizedKey: String {
        switch (digitType, operation) {
        case (.oneDigit, .addition):
            return "one_digit_addition"
        case (.oneDigit, .subtraction):
            return "one_digit_subtraction"
        case (.oneDigit, .multiplication):
            return "one_digit_multiplication"
        case (.oneDigit, .division):
            return "one_digit_division"
        case (.twoDigit, .addition):
            return "two_digit_addition"
        case (.twoDigit, .subtraction):
            return "two_digit_subtraction"
        case (.twoDigit, .multiplication):
            return "two_digit_multiplication"
        case (.twoDigit, .division):
            return "two_digit_division"
        }
    }
    
    var icon: String {
        switch operation {
        case .addition:
            return "plus.circle.fill"
        case .subtraction:
            return "minus.circle.fill"
        case .multiplication:
            return "multiply.circle.fill"
        case .division:
            return "divide.circle.fill"
        }
    }
    
    var color: String {
        switch operation {
        case .addition:
            return "green"
        case .subtraction:
            return "orange"
        case .multiplication:
            return "blue"
        case .division:
            return "purple"
        }
    }
    
    static let allCategories: [MathCategory] = {
        var categories: [MathCategory] = []
        for digitType in DigitType.allCases {
            for operation in OperationType.allCases {
                categories.append(MathCategory(operation: operation, digitType: digitType))
            }
        }
        return categories
    }()
}
