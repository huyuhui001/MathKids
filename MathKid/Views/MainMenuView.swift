//
//  MainMenuView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var userProgress: UserProgress
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var navigationManager = NavigationManager()
    
    // MathSuperKid风格的颜色
    private let primaryGradient = LinearGradient(
        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MathSuperKid风格的紫蓝渐变背景
                primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🧮")
                                .font(.system(size: 60))
                            
                            Text(appSettings.localizedString("app_title"))
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                                .multilineTextAlignment(.center)
                            
                            Text("选择适合你的练习难度")
                                .font(.system(size: 22, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                        
                        // Difficulty Level Cards - MathSuperKid风格
                        VStack(spacing: 16) {
                            LevelCard(
                                icon: "🌱",
                                name: "入门阶段",
                                description: "10以内加减法",
                                color: Color(hex: "4CAF50"),
                                colorHex: "4CAF50",
                                iconSize: 36,
                                nameSize: 24,
                                descSize: 18,
                                arrowSize: 28
                            )
                            .onTapGesture {
                                selectedLevel = .beginner
                                navigationManager.selectedLevel = .beginner
                                navigationManager.showCategorySelection = true
                            }
                            
                            LevelCard(
                                icon: "☀️",
                                name: "基础阶段",
                                description: "20以内加减法",
                                color: Color(hex: "FF9800"),
                                colorHex: "FF9800",
                                iconSize: 36,
                                nameSize: 24,
                                descSize: 18,
                                arrowSize: 28
                            )
                            .onTapGesture {
                                selectedLevel = .basic
                                navigationManager.selectedLevel = .basic
                                navigationManager.showCategorySelection = true
                            }
                            
                            LevelCard(
                                icon: "🌟",
                                name: "提升阶段",
                                description: "两位数加减法",
                                color: Color(hex: "667eea"),
                                colorHex: "667eea",
                                iconSize: 36,
                                nameSize: 24,
                                descSize: 18,
                                arrowSize: 28
                            )
                            .onTapGesture {
                                selectedLevel = .advanced
                                navigationManager.selectedLevel = .advanced
                                navigationManager.showCategorySelection = true
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Tips Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("💡 练习小贴士")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("• 入门阶段：简单的加减法运算")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("• 基础阶段：20以内加减法运算")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("• 提升阶段：两位数加减法运算")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(24)
                        .background(.white.opacity(0.15))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // Bottom Start Button
                VStack {
                    Spacer()
                    
                    Button(action: {
                        navigationManager.selectedLevel = selectedLevel
                        navigationManager.showCategorySelection = true
                    }) {
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
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $navigationManager.showCategorySelection) {
                CategorySelectionView(selectedLevel: navigationManager.selectedLevel)
                    .environmentObject(navigationManager)
            }
            .onChange(of: navigationManager.shouldPopToRoot) { _, newValue in
                if newValue {
                    navigationManager.showCategorySelection = false
                    navigationManager.shouldPopToRoot = false
                }
            }
        }
        .environmentObject(navigationManager)
    }
    
    @State private var selectedLevel: LevelType = .beginner
}

enum LevelType: String, CaseIterable {
    case beginner = "beginner"
    case basic = "basic"
    case advanced = "advanced"
}

struct LevelCard: View {
    let icon: String
    let name: String
    let description: String
    let color: Color
    let colorHex: String
    var iconSize: CGFloat = 50
    var nameSize: CGFloat = 32
    var descSize: CGFloat = 24
    var arrowSize: CGFloat = 36
    
    var body: some View {
        HStack(spacing: 20) {
            Text(icon)
                .font(.system(size: iconSize))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.system(size: nameSize, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: descSize))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Spacer()
            
            Text("→")
                .font(.system(size: arrowSize))
                .foregroundColor(.gray)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: 8),
            alignment: .leading
        )
    }
}

// Color extension for hex support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MainMenuView()
        .environmentObject(UserProgress())
}