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
    
    func addScore(_ points: Int) {
        totalScore += points
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
