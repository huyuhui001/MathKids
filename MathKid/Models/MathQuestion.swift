//
//  MathQuestion.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import Foundation

struct MathQuestion: Identifiable {
    let id = UUID()
    let operand1: Int
    let operand2: Int
    let operation: OperationType
    let correctAnswer: Int
    
    var questionText: String {
        "\(operand1) \(operation.rawValue) \(operand2) = ?"
    }
    
    init(operand1: Int, operand2: Int, operation: OperationType) {
        self.operand1 = operand1
        self.operand2 = operand2
        self.operation = operation
        
        switch operation {
        case .addition:
            self.correctAnswer = operand1 + operand2
        case .subtraction:
            self.correctAnswer = operand1 - operand2
        case .multiplication:
            self.correctAnswer = operand1 * operand2
        case .division:
            self.correctAnswer = operand1 / operand2
        }
    }
    
    func checkAnswer(_ answer: Int) -> Bool {
        return answer == correctAnswer
    }
}

class QuestionGenerator {
    static func generate(category: MathCategory, difficulty: DifficultyLevel) -> MathQuestion {
        let range = difficulty.numberRange(for: category.digitType, operation: category.operation)
        
        switch category.operation {
        case .addition:
            let num1 = Int.random(in: range)
            let num2 = Int.random(in: range)
            return MathQuestion(operand1: num1, operand2: num2, operation: .addition)
            
        case .subtraction:
            // Ensure result is positive
            let num1 = Int.random(in: range)
            let num2 = Int.random(in: range.lowerBound...num1)
            return MathQuestion(operand1: num1, operand2: num2, operation: .subtraction)
            
        case .multiplication:
            let num1 = Int.random(in: range)
            let num2 = Int.random(in: range)
            return MathQuestion(operand1: num1, operand2: num2, operation: .multiplication)
            
        case .division:
            // Ensure clean division (no remainder)
            let num2 = Int.random(in: range)
            let multiplier = Int.random(in: range)
            let num1 = num2 * multiplier
            return MathQuestion(operand1: num1, operand2: num2, operation: .division)
        }
    }
    
    static func generateQuestions(category: MathCategory, difficulty: DifficultyLevel, count: Int) -> [MathQuestion] {
        var questions: [MathQuestion] = []
        for _ in 0..<count {
            questions.append(generate(category: category, difficulty: difficulty))
        }
        return questions
    }
}
