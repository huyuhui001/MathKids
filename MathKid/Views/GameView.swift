//
//  GameView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI
import Combine

struct GameView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var navigationManager: NavigationManager
    let level: LevelType
    let difficulty: DifficultyLevel
    let questionCount: Int
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var gameSession: GameSession
    @State private var userAnswer: String = ""
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var showResult = false
    
    init(level: LevelType, difficulty: DifficultyLevel, questionCount: Int) {
        self.level = level
        self.difficulty = difficulty
        self.questionCount = questionCount
        
        // 不在init中生成题目，让resetGame处理
        _gameSession = StateObject(wrappedValue: GameSession(questions: []))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "f5f5f5").ignoresSafeArea()
            
            VStack(spacing: 16) {
                statsBar
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(gameSession.questions.enumerated()), id: \.element.id) { index, question in
                            questionRow(index: index, question: question)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
                
                bottomButtons
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button("返回") { dismiss() })
        .navigationDestination(isPresented: $showResult) {
            ResultView(
                gameSession: gameSession,
                level: level,
                difficulty: difficulty,
                questionCount: questionCount
            )
            .environmentObject(navigationManager)
        }
        .onAppear {
            // 重新生成题目，确保每次进入都是新题目
            // 这包含了"再练一次"的场景
            resetGame()
        }
    }
    
    private func questionRow(index: Int, question: MathQuestion) -> some View {
        // 创建一个稳定的Binding来访问问题
        let userAnswerBinding: Binding<String> = Binding(
            get: {
                // 直接从gameSession获取最新的userAnswer
                if let q = gameSession.questions.first(where: { $0.id == question.id }) {
                    return q.userAnswer
                }
                return question.userAnswer
            },
            set: { newValue in
                // 更新gameSession中的数据
                if let questionIndex = gameSession.questions.firstIndex(where: { $0.id == question.id }) {
                    gameSession.questions[questionIndex].userAnswer = newValue
                }
            }
        )
        
        return VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("\(index + 1).")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 40, alignment: .leading)
                
                Text(question.questionText)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.black)
                
                // 每道题的输入框（未提交前可编辑）
                TextField("?", text: userAnswerBinding)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black) // 确保文本颜色为黑色，提高可读性
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .frame(width: 80, height: 50)
                    .background(Color(hex: "f8f8f8"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "ddd"), lineWidth: 2)
                    )
                    .disabled(question.isCorrect != nil)
                
                Spacer()
                
                // 正确/错误标记（提交后或已回答的题目显示）
                if let correct = question.isCorrect {
                    Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(correct ? Color(hex: "4CAF50") : Color(hex: "f44336"))
                } else if !(gameSession.questions.first(where: { $0.id == question.id })?.userAnswer.isEmpty ?? true) && !showFeedback {
                    // 有答案但未提交，显示等待标记
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "FF9800"))
                }
            }
            
            // 显示正确答案（答错时）
            if question.isCorrect == false {
                HStack {
                    Text("正确答案: \(question.correctAnswer)")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "f44336"))
                    Spacer()
                }
                .padding(.leading, 52)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(
            Rectangle()
                .fill(
                    question.isCorrect == nil ? Color(hex: "e0e0e0") :
                        (question.isCorrect == true ? Color(hex: "4CAF50") : Color(hex: "f44336"))
                )
                .frame(width: 5),
            alignment: .leading
        )
    }
    
    private var statsBar: some View {
        HStack {
            statColumn(label: "正确", value: "\(gameSession.correctAnswers)", color: Color(hex: "4CAF50"))
            Spacer()
            statColumn(label: "错误", value: "\(gameSession.wrongAnswers)", color: Color(hex: "f44336"))
            Spacer()
            statColumn(label: "得分", value: "\(gameSession.score)", color: Color(hex: "667eea"))
            Spacer()
            statColumn(label: "用时", value: gameSession.usedTimeString, color: Color(hex: "FF9800"))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private func statColumn(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label).font(.system(size: 18)).foregroundColor(.gray)
            Text(value).font(.system(size: 24, weight: .bold)).foregroundColor(color)
        }
    }
    
    private var bottomButtons: some View {
        VStack(spacing: 12) {
            // 统一提交按钮（提交所有答案）
            if !showFeedback {
                Button(action: submitAllAnswers) {
                    Text("提交答案")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(LinearGradient(colors: [Color(hex: "4CAF50"), Color(hex: "2e7d32")], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(38)
                }
                .padding(.horizontal, 16)
            }
            
            // 完成按钮（提交后显示）
            if showFeedback {
                Button(action: {
                    userProgress.addScore(gameSession.score)
                    showResult = true
                }) {
                    Text("完成练习")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(hex: "667eea"))
                        .cornerRadius(38)
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 20)
        .background(Color.white.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5))
    }
    
    // 提交所有答案
    private func submitAllAnswers() {
        for i in 0..<gameSession.questions.count {
            let question = gameSession.questions[i]
            // 只提交有答案的题目
            if let answer = Int(question.userAnswer), answer > 0 {
                _ = gameSession.submitAnswer(at: i, answer: answer)
            } else if let answer = Int(question.userAnswer), answer == 0 {
                // 0也是有效答案
                _ = gameSession.submitAnswer(at: i, answer: 0)
            }
        }
        showFeedback = true
    }
}

// GameSession
class GameSession: ObservableObject {
    @Published var questions: [MathQuestion]
    @Published var currentQuestionIndex: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var wrongAnswers: Int = 0
    @Published var score: Int = 0
    @Published var startTime: Date
    
    var usedTimeString: String {
        let elapsed = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return minutes > 0 ? "\(minutes)分\(seconds)秒" : "\(seconds)秒"
    }
    
    var accuracy: Double {
        let total = correctAnswers + wrongAnswers
        guard total > 0 else { return 0 }
        return Double(correctAnswers) / Double(total)
    }
    
    init(questions: [MathQuestion]) {
        self.questions = questions
        self.startTime = Date()
    }
    
    func submitAnswer(at index: Int, answer: Int) -> Bool {
        guard index < questions.count else { return false }
        let isCorrect = answer == questions[index].correctAnswer
        questions[index].userAnswer = String(answer)
        questions[index].isCorrect = isCorrect
        if isCorrect {
            correctAnswers += 1
            score += 10
        } else {
            wrongAnswers += 1
        }
        return isCorrect
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
}

// Helper function to reset game state
extension GameView {
    private func resetGame() {
        let maxNumber = level.maxNumber
        let questions = QuestionGenerator.generateQuestions(maxNumber: maxNumber, count: questionCount)
        gameSession.questions = questions
        gameSession.correctAnswers = 0
        gameSession.wrongAnswers = 0
        gameSession.score = 0
        gameSession.startTime = Date()
        gameSession.currentQuestionIndex = 0
        userAnswer = ""
        showFeedback = false
        showResult = false
    }
}

// QuestionGenerator
struct QuestionGenerator {
    static func generateQuestions(maxNumber: Int, count: Int) -> [MathQuestion] {
        (0..<count).map { _ in
            Bool.random() ? generateAddition(maxNumber: maxNumber) : generateSubtraction(maxNumber: maxNumber)
        }
    }
    
    static func generateAddition(maxNumber: Int) -> MathQuestion {
        let num1 = Int.random(in: 1...maxNumber)
        let num2 = Int.random(in: 1...maxNumber)
        return MathQuestion(questionText: "\(num1) + \(num2) = ", correctAnswer: num1 + num2)
    }
    
    static func generateSubtraction(maxNumber: Int) -> MathQuestion {
        let num1 = Int.random(in: 1...maxNumber)
        let num2 = Int.random(in: 1...num1)
        return MathQuestion(questionText: "\(num1) − \(num2) = ", correctAnswer: num1 - num2)
    }
}

// MathQuestion
struct MathQuestion: Identifiable {
    let id = UUID()
    let questionText: String
    let correctAnswer: Int
    var userAnswer: String = ""
    var isCorrect: Bool? = nil
}

// LevelType extension
extension LevelType {
    var maxNumber: Int {
        switch self {
        case .beginner: return 10
        case .basic: return 20
        case .advanced: return 99
        }
    }
}