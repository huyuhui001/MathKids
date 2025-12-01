//
//  MathKidApp.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

@main
struct MathKidApp: App {
    @StateObject private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appSettings)
                .environment(\.locale, appSettings.currentLocale)
        }
    }
}
