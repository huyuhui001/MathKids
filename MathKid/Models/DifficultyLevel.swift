//
//  DifficultyLevel.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import Foundation

enum DifficultyLevel: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    
    var id: String { rawValue }
    
    var localizedKey: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .easy:
            return "star.fill"
        case .medium:
            return "star.leadinghalf.filled"
        case .hard:
            return "crown.fill"
        }
    }
    
    var questionsCount: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 8
        case .hard:
            return 10
        }
    }
    
    var timeLimit: Int? {
        switch self {
        case .easy:
            return nil // No time limit
        case .medium:
            return 30 // 30 seconds per question
        case .hard:
            return 20 // 20 seconds per question
        }
    }
    
    var pointsPerQuestion: Int {
        switch self {
        case .easy:
            return 10
        case .medium:
            return 20
        case .hard:
            return 30
        }
    }
    
    // For 1-digit numbers
    func numberRange(for digitType: DigitType, operation: OperationType) -> ClosedRange<Int> {
        switch (digitType, self) {
        case (.oneDigit, .easy):
            return operation == .division ? 1...5 : 1...5
        case (.oneDigit, .medium):
            return operation == .division ? 1...7 : 1...7
        case (.oneDigit, .hard):
            return operation == .division ? 1...9 : 1...9
        case (.twoDigit, .easy):
            return operation == .division ? 10...20 : 10...30
        case (.twoDigit, .medium):
            return operation == .division ? 10...50 : 10...60
        case (.twoDigit, .hard):
            return operation == .division ? 10...99 : 10...99
        }
    }
}
