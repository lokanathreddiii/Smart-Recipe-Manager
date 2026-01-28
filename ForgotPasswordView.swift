//
//  ForgotPasswordView.swift
//  SmartRecipeManager
//
//  Created by RPS on 23/01/26.
//

import SwiftUI

struct ForgotPasswordView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer()

                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Enter your registered email to reset your password.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button {
                    resetPassword()
                } label: {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Reset Password")
            .alert("Password Reset",
                   isPresented: $showConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("A password reset link has been sent to \(email).")
            }
        }
    }

    private func resetPassword() {
        // TEMP reset logic
        print("Reset password for:", email)
        showConfirmation = true
    }
}

#Preview {
    ForgotPasswordView()
}
