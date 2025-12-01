//
//  AppSettings.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI
import Combine

class AppSettings: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            // Force update by triggering objectWillChange
            objectWillChange.send()
        }
    }
    
    init() {
        self.selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    }
    
    var currentLocale: Locale {
        Locale(identifier: selectedLanguage)
    }
    
    func localizedString(_ key: String) -> String {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: selectedLanguage, ofType: "lproj"),
           let locBundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: locBundle, comment: "")
        }
        return NSLocalizedString(key, comment: "")
    }
}
