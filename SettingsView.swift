//
//  SettingsView.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//
import SwiftUI

struct SettingsView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var authManager: AuthManager

    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            Form {

                // Appearance Section
                Section(header: Text("Appearance")) {
                    Picker("App Theme", selection: $themeManager.selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName)
                                .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Account Section
                Section(header: Text("Account")) {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        Text("Sign Out")
                    }
                }

                Section {
                    Text("You will be redirected to the login screen after signing out.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out?",
                   isPresented: $showLogoutAlert) {

                Button("Sign Out", role: .destructive) {
                    authManager.logout()
                }

                Button("Cancel", role: .cancel) {}

            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
        .environmentObject(AuthManager())
}
