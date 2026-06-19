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
    case custom
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .easy:
            return "star.fill"
        case .medium:
            return "star.leadinghalf.filled"
        case .hard:
            return "crown.fill"
        case .custom:
            return "slider.horizontal.3"
        }
    }
    
    var questionsCount: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 10
        case .hard:
            return 15
        case .custom:
            return 20
        }
    }
}
