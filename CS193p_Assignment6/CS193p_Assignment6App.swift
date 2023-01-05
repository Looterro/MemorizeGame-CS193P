//
//  CS193p_Assignment6App.swift
//  CS193p_Assignment6
//
//  Created by Jakub Łata on 05/01/2023.
//

import SwiftUI

@main
struct CS193p_Assignment6App: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeManager()
                .environmentObject(themeStore)
        }
    }
}
