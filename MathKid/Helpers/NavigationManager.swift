//
//  NavigationManager.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI
import Combine

// 导航管理器，用于在视图之间共享导航状态
class NavigationManager: ObservableObject {
    // 是否显示CategorySelectionView
    @Published var showCategorySelection: Bool = false
    
    // 是否显示GameView
    @Published var showGameView: Bool = false
    
    // 是否显示ResultView
    @Published var showResult: Bool = false
    
    // 选中的等级
    @Published var selectedLevel: LevelType = .beginner
    
    // 选中的难度
    @Published var selectedDifficulty: DifficultyLevel = .easy
    
    // 题目数量
    @Published var questionCount: Int = 10
    
    // 请求导航到Category
    @Published var requestNavigateToCategory: Bool = false
    
    // 请求导航到Game
    @Published var requestNavigateToGame: Bool = false
    
    // 请求导航到Result
    @Published var requestNavigateToResult: Bool = false
    
    // 标记是否应该返回到首页
    @Published var shouldPopToRoot: Bool = false
    
    // 重置GameView的触发器（每次"再练一次"会递增）
    @Published var gameResetTrigger: Int = 0
    
    func resetNavigation() {
        shouldPopToRoot = true
    }
    
    // 触发GameView重置
    func triggerGameReset() {
        gameResetTrigger += 1
    }
}
