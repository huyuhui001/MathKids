//
//  GameView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var appSettings: AppSettings
    let category: MathCategory
    let difficulty: DifficultyLevel
    
    @EnvironmentObject var userProgress: UserProgress
    @Environment(\.dismiss) var dismiss
    
    @State private var gameSession: GameSession
    @State private var userAnswer: String = ""
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var showResult = false
    @State private var animateCorrect = false
    
    init(category: MathCategory, difficulty: DifficultyLevel) {
        self.category = category
        self.difficulty = difficulty
        let questions = QuestionGenerator.generateQuestions(
            category: category,
            difficulty: difficulty,
            count: difficulty.questionsCount
        )
        _gameSession = State(initialValue: GameSession(
            category: category,
            difficulty: difficulty,
            questions: questions
        ))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.cyan.opacity(0.3), .mint.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header with progress
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(appSettings.localizedString("question")) \(gameSession.currentQuestionIndex + 1)/\(gameSession.questions.count)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(appSettings.localizedString("score")): \(gameSession.score)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Level badge
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(userProgress.currentLevel)")
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.7))
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Progress bar
                ProgressView(value: gameSession.progress)
                    .tint(.blue)
                    .padding(.horizontal)
                
                Spacer()
                
                // Question Display
                if let question = gameSession.currentQuestion {
                    VStack(spacing: 30) {
                        Text(question.questionText)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(.white)
                                    .shadow(radius: 10)
                            )
                            .scaleEffect(animateCorrect ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3), value: animateCorrect)
                        
                        // Answer input
                        if !showFeedback {
                            VStack(spacing: 15) {
                                TextField(appSettings.localizedString("your_answer"), text: $userAnswer)
                                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                
                                Button(action: submitAnswer) {
                                    Text(appSettings.localizedString("submit"))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 18)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(15)
                                        .shadow(radius: 5)
                                }
                                .disabled(userAnswer.isEmpty)
                                .opacity(userAnswer.isEmpty ? 0.5 : 1.0)
                            }
                            .padding(.horizontal)
                        } else {
                            // Feedback
                            VStack(spacing: 20) {
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(isCorrect ? .green : .red)
                                
                                Text(appSettings.localizedString(isCorrect ? "correct" : "incorrect"))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(isCorrect ? .green : .red)
                                
                                if !isCorrect, let question = gameSession.currentQuestion {
                                    Text("\(question.correctAnswer)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(.primary)
                                }
                                
                                Button(action: nextQuestion) {
                                    Text(gameSession.currentQuestionIndex < gameSession.questions.count - 1 ?
                                         appSettings.localizedString("next") : appSettings.localizedString("finish"))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 18)
                                        .background(.blue)
                                        .cornerRadius(15)
                                        .shadow(radius: 5)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(appSettings.localizedString("back_to_menu"))
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showResult) {
            ResultView(gameSession: gameSession, category: category)
        }
    }
    
    private func submitAnswer() {
        guard let answer = Int(userAnswer) else { return }
        
        isCorrect = gameSession.submitAnswer(answer)
        showFeedback = true
        
        if isCorrect {
            animateCorrect = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateCorrect = false
            }
        }
    }
    
    private func nextQuestion() {
        gameSession.nextQuestion()
        userAnswer = ""
        showFeedback = false
        
        if gameSession.isComplete {
            // Update user progress
            userProgress.addScore(gameSession.score, for: category)
            showResult = true
        }
    }
}

#Preview {
    NavigationStack {
        GameView(
            category: MathCategory(operation: .addition, digitType: .oneDigit),
            difficulty: .easy
        )
        .environmentObject(UserProgress())
    }
}
