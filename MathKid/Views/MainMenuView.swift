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
    @State private var showCategorySelection = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.6), .purple.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Language Selector at top
                    HStack {
                        Spacer()
                        Menu {
                            Button(action: {
                                appSettings.selectedLanguage = "en"
                            }) {
                                HStack {
                                    Text("English")
                                    if appSettings.selectedLanguage == "en" {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            
                            Button(action: {
                                appSettings.selectedLanguage = "zh-Hans"
                            }) {
                                HStack {
                                    Text("中文")
                                    if appSettings.selectedLanguage == "zh-Hans" {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "globe")
                                Text(appSettings.selectedLanguage == "zh-Hans" ? "中文" : "English")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.3))
                            .cornerRadius(20)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // App Title with animation
                    VStack(spacing: 10) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                        
                        Text(appSettings.localizedString("app_title"))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // User Stats
                    VStack(spacing: 15) {
                        HStack(spacing: 40) {
                            StatBadge(
                                icon: "star.fill",
                                title: appSettings.localizedString("level"),
                                value: "\(userProgress.currentLevel)",
                                color: .yellow
                            )
                            
                            StatBadge(
                                icon: "rosette",
                                title: appSettings.localizedString("score"),
                                value: "\(userProgress.totalScore)",
                                color: .orange
                            )
                        }
                    }
                    .padding()
                    .background(.white.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Start Button
                    Button(action: {
                        showCategorySelection = true
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.title2)
                            Text(appSettings.localizedString("start_game"))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showCategorySelection) {
                CategorySelectionView()
            }
        }
    }
}

struct StatBadge: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MainMenuView()
        .environmentObject(UserProgress())
}
