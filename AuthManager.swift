//
//  AuthManager.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//
import SwiftUI

final class AuthManager: ObservableObject {

    // Login state
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    // Stored user credentials (LOCAL)
    @AppStorage("registeredEmail") private var registeredEmail: String = ""
    @AppStorage("registeredPassword") private var registeredPassword: String = ""

    // SIGN UP
    func signup(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            return false
        }

        registeredEmail = email
        registeredPassword = password
        return true
    }

    // LOGIN
    func login(email: String, password: String) -> Bool {
        if email == registeredEmail && password == registeredPassword {
            isLoggedIn = true
            return true
        }
        return false
    }

    // LOGOUT
    func logout() {
        isLoggedIn = false
    }

    // FORGOT PASSWORD (SIMULATION)
    func isRegistered(email: String) -> Bool {
        return email == registeredEmail
    }
}
