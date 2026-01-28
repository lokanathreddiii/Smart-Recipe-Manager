//
//  SmartRecipeManagerApp.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//
import SwiftUI

@main
struct SmartRecipeManagerApp: App {

    let persistenceController = PersistenceController.shared

    @StateObject private var authManager = AuthManager()
    @StateObject private var themeManager = ThemeManager()   // ✅ REQUIRED

    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoggedIn {
                    ContentView()
                        .environment(
                            \.managedObjectContext,
                            persistenceController.container.viewContext
                        )
                } else {
                    LoginView()
                }
            }
            // ✅ THESE TWO FIX THE CRASH
            .environmentObject(authManager)
            .environmentObject(themeManager)
            .preferredColorScheme(themeManager.selectedTheme.colorScheme)
        }
    }
}
