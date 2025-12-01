//
//  ResultView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var appSettings: AppSettings
    let gameSession: GameSession
    let category: MathCategory
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProgress: UserProgress
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.yellow.opacity(0.3), .orange.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Celebration Icon
                Image(systemName: gameSession.accuracy >= 0.9 ? "trophy.fill" : 
                      gameSession.accuracy >= 0.7 ? "star.fill" : "flag.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow)
                    .shadow(radius: 10)
                
                // Performance Message
                Text(appSettings.localizedString(gameSession.performanceMessage))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Statistics
                VStack(spacing: 20) {
                    StatRow(
                        icon: "checkmark.circle.fill",
                        title: appSettings.localizedString("correct"),
                        value: "\(gameSession.correctAnswers)/\(gameSession.questions.count)",
                        color: .green
                    )
                    
                    StatRow(
                        icon: "percent",
                        title: "Accuracy",
                        value: String(format: "%.0f%%", gameSession.accuracy * 100),
                        color: .blue
                    )
                    
                    StatRow(
                        icon: "star.fill",
                        title: appSettings.localizedString("score"),
                        value: "\(gameSession.score)",
                        color: .orange
                    )
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    StatRow(
                        icon: "crown.fill",
                        title: appSettings.localizedString("total_score"),
                        value: "\(userProgress.totalScore)",
                        color: .purple
                    )
                    
                    StatRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: appSettings.localizedString("level"),
                        value: "\(userProgress.currentLevel)",
                        color: .cyan
                    )
                }
                .padding()
                .background(.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Navigate back to difficulty selection (dismiss once to stay in same category)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title3)
                            Text(appSettings.localizedString("play_again"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        // Navigate back to main menu (dismiss all the way)
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.title3)
                            Text(appSettings.localizedString("back_to_menu"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

#Preview {
    let session = GameSession(
        category: MathCategory(operation: .addition, digitType: .oneDigit),
        difficulty: .easy,
        questions: QuestionGenerator.generateQuestions(
            category: MathCategory(operation: .addition, digitType: .oneDigit),
            difficulty: .easy,
            count: 5
        ),
        currentQuestionIndex: 5,
        correctAnswers: 4,
        score: 40
    )
    
    return NavigationStack {
        ResultView(gameSession: session, category: MathCategory(operation: .addition, digitType: .oneDigit))
            .environmentObject(UserProgress())
    }
}
