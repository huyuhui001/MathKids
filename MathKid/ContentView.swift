//
//  ContentView.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userProgress = UserProgress()
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        MainMenuView()
            .environmentObject(userProgress)
            .environmentObject(appSettings)
    }
}

#Preview {
    ContentView()
}
