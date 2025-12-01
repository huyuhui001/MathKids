//
//  UserProgress.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import Foundation
import Combine

class UserProgress: ObservableObject {
    @Published var totalScore: Int = 0
    @Published var currentLevel: Int = 1
    @Published var categoryScores: [String: Int] = [:]
    
    func addScore(_ points: Int, for category: MathCategory) {
        totalScore += points
        let key = category.localizedKey
        categoryScores[key, default: 0] += points
        updateLevel()
    }
    
    private func updateLevel() {
        // Level up every 100 points
        currentLevel = (totalScore / 100) + 1
    }
    
    func reset() {
        totalScore = 0
        currentLevel = 1
        categoryScores.removeAll()
    }
}

struct GameSession {
    let category: MathCategory
    let difficulty: DifficultyLevel
    let questions: [MathQuestion]
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var score: Int = 0
    
    var currentQuestion: MathQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var isComplete: Bool {
        return currentQuestionIndex >= questions.count
    }
    
    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }
    
    mutating func submitAnswer(_ answer: Int) -> Bool {
        guard let question = currentQuestion else { return false }
        let isCorrect = question.checkAnswer(answer)
        
        if isCorrect {
            correctAnswers += 1
            score += difficulty.pointsPerQuestion
        }
        
        return isCorrect
    }
    
    mutating func nextQuestion() {
        currentQuestionIndex += 1
    }
    
    var accuracy: Double {
        guard currentQuestionIndex > 0 else { return 0 }
        return Double(correctAnswers) / Double(currentQuestionIndex)
    }
    
    var performanceMessage: String {
        let percentage = accuracy * 100
        
        if percentage >= 90 {
            return "excellent"
        } else if percentage >= 70 {
            return "good_job"
        } else {
            return "keep_practicing"
        }
    }
}
