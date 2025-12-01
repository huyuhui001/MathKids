//
//  LocalizedText.swift
//  MathKid
//
//  Created by Hu, James on 2025/11/30.
//

import SwiftUI

struct LocalizedText: View {
    let key: String
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        Text(appSettings.localizedString(key))
    }
}
