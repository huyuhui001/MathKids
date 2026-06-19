//
//  CategorySelectionView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var navigationManager: NavigationManager
    
    let selectedLevel: LevelType
    
    @State private var showGameView = false
    @State private var selectedDifficulty: DifficultyLevel?
    
    // 题型配置
    @State private var questionTypeConfigs: [QuestionTypeConfig] = []
    @State private var totalQuestions: Int = 20
    
    // 跟踪视图是否被重复访问（用于"再练一次"时重新生成题目）
    @State private var viewAppearedCount = 0
    
    var body: some View {
        ZStack {
            // MathSuperKid风格的紫蓝渐变背景
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Level Header
                    levelHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // Question Type Selection
                    questionTypeSection
                        .padding(.horizontal, 20)
                    
                    // Total Count Display
                    totalCountSection
                        .padding(.horizontal, 20)
                    
                    // Start Button
                    startButton
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showGameView) {
            if let difficulty = selectedDifficulty {
                GameView(
                    level: selectedLevel,
                    difficulty: difficulty,
                    questionCount: totalQuestions
                )
                .environmentObject(navigationManager)
            }
        }
        .onAppear {
            viewAppearedCount += 1
            loadDefaultConfigs()
        }
    }
    
    // Level Header
    private var levelHeader: some View {
        HStack(spacing: 16) {
            Text(levelInfo.icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(levelInfo.name)
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Text(levelInfo.description)
                    .font(.system(size: 20))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(levelInfo.color)
                .frame(width: 8),
            alignment: .leading
        )
    }
    
    // Question Type Section
    private var questionTypeSection: some View {
        VStack(spacing: 16) {
            // Action Bar
            HStack {
                Button(action: selectAll) {
                    Text("全选")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "667eea"))
                }
                
                Text("|")
                    .foregroundColor(.gray)
                
                Button(action: deselectAll) {
                    Text("全不选")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "667eea"))
                }
                
                Spacer()
                
                Toggle("综合练习", isOn: $isComprehensiveMode)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "4CAF50")))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.95))
            )
            
            // Question Type List
            VStack(spacing: 12) {
                ForEach($questionTypeConfigs) { $config in
                    QuestionTypeRow(config: $config, isDisabled: isComprehensiveMode) { newCount in
                        calculateTotal()
                    }
                }
            }
        }
    }
    
    // Total Count Section
    private var totalCountSection: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Text("总题目数")
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(totalQuestions)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Text("道")
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding(.top, 30)
    }
    
    // Start Button
    private var startButton: some View {
        Button(action: startExercise) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.title3)
                Text("开始练习")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .tracking(4)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "FF9A56"), Color(hex: "FF6A00")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(50)
            .shadow(color: Color(hex: "FF6A00").opacity(0.4), radius: 15, x: 0, y: 10)
        }
        .disabled(totalQuestions < 1)
        .opacity(totalQuestions < 1 ? 0.5 : 1.0)
    }
    
    // Computed Properties
    @State private var isComprehensiveMode = false
    
    private var levelInfo: LevelInfo {
        switch selectedLevel {
        case .beginner:
            return LevelInfo(
                icon: "🌱",
                name: "入门阶段",
                description: "10以内加减法",
                color: Color(hex: "4CAF50"),
                maxNumber: 10
            )
        case .basic:
            return LevelInfo(
                icon: "☀️",
                name: "基础阶段",
                description: "20以内加减法",
                color: Color(hex: "FF9800"),
                maxNumber: 20
            )
        case .advanced:
            return LevelInfo(
                icon: "🌟",
                name: "提升阶段",
                description: "两位数加减法",
                color: Color(hex: "667eea"),
                maxNumber: 99
            )
        }
    }
    
    // Methods
    private func loadDefaultConfigs() {
        switch selectedLevel {
        case .beginner:
            questionTypeConfigs = [
                QuestionTypeConfig(id: "add_10", name: "10以内加法", description: "如: 3 + 5 = 8", defaultCount: 10, maxNumber: 10, operations: [.addition]),
                QuestionTypeConfig(id: "sub_10", name: "10以内减法", description: "如: 8 - 3 = 5", defaultCount: 10, maxNumber: 10, operations: [.subtraction])
            ]
        case .basic:
            questionTypeConfigs = [
                QuestionTypeConfig(id: "add_no_carry_20", name: "20以内不进位加法", description: "如: 12 + 5 = 17", defaultCount: 10, maxNumber: 20, operations: [.addition]),
                QuestionTypeConfig(id: "sub_no_borrow_20", name: "20以内不退位减法", description: "如: 18 - 5 = 13", defaultCount: 10, maxNumber: 20, operations: [.subtraction]),
                QuestionTypeConfig(id: "add_carry_20", name: "20以内进位加法", description: "如: 8 + 5 = 13", defaultCount: 10, maxNumber: 20, operations: [.addition]),
                QuestionTypeConfig(id: "sub_borrow_20", name: "20以内退位减法", description: "如: 15 - 8 = 7", defaultCount: 10, maxNumber: 20, operations: [.subtraction])
            ]
        case .advanced:
            questionTypeConfigs = [
                QuestionTypeConfig(id: "add_2digit", name: "两位数加法", description: "如: 23 + 45 = 68", defaultCount: 10, maxNumber: 99, operations: [.addition]),
                QuestionTypeConfig(id: "sub_2digit", name: "两位数减法", description: "如: 68 - 23 = 45", defaultCount: 10, maxNumber: 99, operations: [.subtraction])
            ]
        }
        
        // 综合练习模式默认全选
        if isComprehensiveMode {
            selectAll()
        }
        
        calculateTotal()
    }
    
    private func selectAll() {
        for i in questionTypeConfigs.indices {
            questionTypeConfigs[i].isSelected = true
        }
        calculateTotal()
    }
    
    private func deselectAll() {
        for i in questionTypeConfigs.indices {
            questionTypeConfigs[i].isSelected = false
        }
        calculateTotal()
    }
    
    private func calculateTotal() {
        totalQuestions = questionTypeConfigs.filter { $0.isSelected }.reduce(0) { $0 + $1.count }
    }
    
    private func startExercise() {
        guard totalQuestions > 0 else { return }
        
        // 转换为GameView所需的参数
        selectedDifficulty = .custom
        showGameView = true
    }
    
    // 重新开始练习（用于从ResultView返回时）
    func restartExercise() {
        // 重新生成所有题目的配置
        loadDefaultConfigs()
    }
}

// Supporting Types
struct LevelInfo {
    let icon: String
    let name: String
    let description: String
    let color: Color
    let maxNumber: Int
}

struct QuestionTypeConfig: Identifiable {
    let id: String
    let name: String
    let description: String
    var defaultCount: Int
    var maxNumber: Int
    var operations: [OperationType]
    var isSelected: Bool = false
    var count: Int = 5
}

struct QuestionTypeRow: View {
    @Binding var config: QuestionTypeConfig
    let isDisabled: Bool
    let onCountChanged: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Image(systemName: config.isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 40))
                .foregroundColor(config.isSelected ? Color(hex: "4CAF50") : .gray)
                .onTapGesture {
                    if !isDisabled {
                        config.isSelected.toggle()
                        onCountChanged(config.count)
                    }
                }
            
            // Type Info
            VStack(alignment: .leading, spacing: 4) {
                Text(config.name)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.black)
                
                Text(config.description)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Count Input
            HStack(spacing: 8) {
                TextField("", text: Binding(
                    get: { String(config.count) },
                    set: { newValue in
                        if let value = Int(newValue) {
                            config.count = max(1, min(999, value))
                            onCountChanged(config.count)
                        }
                    }
                ))
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(width: 70, height: 50)
                .background(Color(hex: "f5f5f5"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "e0e0e0"), lineWidth: 2)
                )
                .disabled(isDisabled)
                
                Text("道")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(config.isSelected ? 0.98 : 0.9))
                .shadow(
                    color: config.isSelected ? Color.black.opacity(0.1) : .clear,
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

#Preview {
    NavigationStack {
        CategorySelectionView(selectedLevel: .basic)
            .environmentObject(UserProgress())
    }
}