//
//  CategorySelectionView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State private var selectedCategory: MathCategory?
    @State private var showDifficultySelection = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.3), .blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text(appSettings.localizedString("select_category"))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(MathCategory.allCategories, id: \.self) { category in
                            CategoryCard(category: category)
                                .onTapGesture {
                                    selectedCategory = category
                                    showDifficultySelection = true
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showDifficultySelection) {
            if let category = selectedCategory {
                DifficultySelectionView(category: category)
            }
        }
    }
}

struct CategoryCard: View {
    @EnvironmentObject var appSettings: AppSettings
    let category: MathCategory
    
    var cardColor: Color {
        switch category.color {
        case "green": return .green
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: category.icon)
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text(appSettings.localizedString(category.localizedKey))
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardColor.gradient)
                .shadow(color: cardColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    NavigationStack {
        CategorySelectionView()
    }
}
