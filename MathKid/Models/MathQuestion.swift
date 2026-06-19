//
//  MathQuestion.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import Foundation

// Operation type enum for question generation
enum OperationType: String, CaseIterable, Identifiable {
    case addition = "+"
    case subtraction = "−"
    
    var id: String { rawValue }
}
