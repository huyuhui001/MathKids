//
//  DifficultySelectionView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var appSettings: AppSettings
    let category: MathCategory
    @State private var selectedDifficulty: DifficultyLevel?
    @State private var showGameView = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.3), .pink.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Title
                Text(appSettings.localizedString("select_difficulty"))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                
                // Selected Category Display
                VStack(spacing: 10) {
                    Image(systemName: category.icon)
                        .font(.system(size: 50))
                        .foregroundColor(categoryColor)
                    
                    Text(appSettings.localizedString(category.localizedKey))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(.white.opacity(0.7))
                .cornerRadius(20)
                
                Spacer()
                
                // Difficulty Options
                VStack(spacing: 20) {
                    ForEach(DifficultyLevel.allCases) { difficulty in
                        DifficultyCard(difficulty: difficulty)
                            .onTapGesture {
                                selectedDifficulty = difficulty
                                showGameView = true
                            }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showGameView) {
            if let difficulty = selectedDifficulty {
                GameView(category: category, difficulty: difficulty)
            }
        }
    }
    
    var categoryColor: Color {
        switch category.color {
        case "green": return .green
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
}

struct DifficultyCard: View {
    @EnvironmentObject var appSettings: AppSettings
    let difficulty: DifficultyLevel
    
    var difficultyColor: Color {
        switch difficulty {
        case .easy:
            return .green
        case .medium:
            return .orange
        case .hard:
            return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: difficulty.icon)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(appSettings.localizedString(difficulty.localizedKey))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    Label("\(difficulty.questionsCount)", systemImage: "questionmark.circle")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Label("\(difficulty.pointsPerQuestion)pts", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.title2)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(difficultyColor.gradient)
                .shadow(color: difficultyColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        DifficultySelectionView(category: MathCategory(operation: .addition, digitType: .oneDigit))
    }
}
