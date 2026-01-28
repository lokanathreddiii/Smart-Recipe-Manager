//
//  LoginView.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var authManager: AuthManager

    @State private var email: String = ""
    @State private var password: String = ""

    @State private var showSignup = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer()

                Text("Smart Recipe Manager")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button {
                    authManager.login(email: email, password: password)
                } label: {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button("Forgot Password?") {
                    showForgotPassword = true
                }
                .font(.footnote)

                Spacer()

                HStack {
                    Text("New user?")
                    Button("Sign up") {
                        showSignup = true
                    }
                }
                .font(.footnote)
            }
            .padding()
            .navigationDestination(isPresented: $showSignup) {
                SignupView()
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
