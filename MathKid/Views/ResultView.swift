//
//  ResultView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var navigationManager: NavigationManager
    let gameSession: GameSession
    let level: LevelType
    let difficulty: DifficultyLevel
    let questionCount: Int
    
    @Environment(\.dismiss) var dismiss
    
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
                VStack(spacing: 30) {
                    Spacer(minLength: 40)
                    
                    // Celebration Icon
                    celebrationIcon
                    
                    // Performance Message
                    performanceMessage
                    
                    // Statistics Card
                    statisticsCard
                        .padding(.horizontal, 20)
                    
                    // User Progress Card
                    progressCard
                        .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                    
                    // Action Buttons
                    actionButtons
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Celebration Icon
    private var celebrationIcon: some View {
        VStack(spacing: 16) {
            Image(systemName: iconForAccuracy)
                .font(.system(size: 80))
                .foregroundColor(.yellow)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            Text(messageForAccuracy)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    // Performance Message
    private var performanceMessage: some View {
        Text(performanceTitle)
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
    
    // Statistics Card
    private var statisticsCard: some View {
        VStack(spacing: 20) {
            // Correct/Wrong
            HStack(spacing: 40) {
                StatColumn(
                    icon: "checkmark.circle.fill",
                    value: "\(gameSession.correctAnswers)",
                    label: "正确",
                    color: Color(hex: "4CAF50")
                )
                
                Divider()
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.3))
                
                StatColumn(
                    icon: "xmark.circle.fill",
                    value: "\(gameSession.wrongAnswers)",
                    label: "错误",
                    color: Color(hex: "f44336")
                )
            }
            
            Divider()
                .padding(.vertical, 5)
            
            // Accuracy
            HStack {
                Text("正确率")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(String(format: "%.0f%%", gameSession.accuracy * 100))
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: "667eea"))
            }
            
            // Score
            HStack {
                Text("得分")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("\(gameSession.score)")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.orange)
                }
            }
            
            // Time
            HStack {
                Text("用时")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(gameSession.usedTimeString)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: "FF9800"))
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
    }
    
    // Progress Card
    private var progressCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("🏆")
                    .font(.system(size: 32))
                
                Text("总得分")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(userProgress.totalScore)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "9C27B0"))
            }
            
            Divider()
            
            HStack {
                Text("📈")
                    .font(.system(size: 32))
                
                Text("当前等级")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Lv.\(userProgress.currentLevel)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "667eea"))
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
    }
    
    // Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Retry Button - 重新开始新的练习
            Button(action: retryExercise) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title3)
                    Text("再练一次")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "FF9800"), Color(hex: "f57c00")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(38)
                .shadow(color: Color(hex: "FF9800").opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            // Back to Menu Button
            Button(action: backToMenu) {
                HStack {
                    Image(systemName: "house.fill")
                        .font(.title3)
                    Text("返回主页")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 38)
                        .fill(Color.white.opacity(0.9))
                )
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            }
        }
    }
    
    // Computed Properties
    private var iconForAccuracy: String {
        if gameSession.accuracy >= 0.9 {
            return "trophy.fill"
        } else if gameSession.accuracy >= 0.7 {
            return "star.fill"
        } else {
            return "flag.fill"
        }
    }
    
    private var messageForAccuracy: String {
        if gameSession.accuracy >= 0.9 {
            return "太棒了！🎉"
        } else if gameSession.accuracy >= 0.7 {
            return "做得不错！🌟"
        } else {
            return "继续加油！💪"
        }
    }
    
    private var performanceTitle: String {
        if gameSession.accuracy >= 0.9 {
            return "完美表现！"
        } else if gameSession.accuracy >= 0.7 {
            return "表现优秀！"
        } else if gameSession.accuracy >= 0.5 {
            return "还需努力！"
        } else {
            return "继续加油！"
        }
    }
    
    // Actions
    private func retryExercise() {
        // 触发GameView重置信号
        navigationManager.triggerGameReset()
        // 返回到GameView
        dismiss()
    }
    
    private func backToMenu() {
        // 返回到MainMenuView首页
        // 使用NavigationManager重置所有状态，直接跳转到首页
        navigationManager.shouldPopToRoot = true
    }
}

// Stat Column
struct StatColumn: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.black)
            
            Text(label)
                .font(.system(size: 20))
                .foregroundColor(.gray)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        let session = GameSession(
            questions: [
                MathQuestion(questionText: "5 + 3 = ", correctAnswer: 8),
                MathQuestion(questionText: "9 - 4 = ", correctAnswer: 5),
                MathQuestion(questionText: "7 + 6 = ", correctAnswer: 13)
            ]
        )
        session.correctAnswers = 2
        session.wrongAnswers = 1
        session.score = 20
        
        return NavigationStack {
            ResultView(
                gameSession: session,
                level: .beginner,
                difficulty: .easy,
                questionCount: 10
            )
            .environmentObject(UserProgress())
        }
    }
}