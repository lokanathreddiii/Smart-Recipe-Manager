//
//  RecipeStepsView.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//
import SwiftUI

struct RecipeStepsView: View {

    let instructions: String

    @State private var currentStep: Int = 0

    private var steps: [String] {
        instructions
            .components(separatedBy: ["\n", "."])
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(spacing: 24) {

            // Progress
            ProgressView(value: Double(currentStep + 1),
                         total: Double(max(steps.count, 1)))
                .padding(.horizontal)

            // Step Counter
            Text("Step \(currentStep + 1) of \(steps.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Step Content
            ZStack {
                Text(steps.isEmpty ? "No steps available." : steps[currentStep])
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            .animation(.easeInOut, value: currentStep)

            // Controls
            HStack(spacing: 20) {

                Button {
                    if currentStep > 0 {
                        currentStep -= 1
                    }
                } label: {
                    Label("Previous", systemImage: "chevron.left")
                }
                .disabled(currentStep == 0)

                Spacer()

                Button {
                    if currentStep < steps.count - 1 {
                        currentStep += 1
                    }
                } label: {
                    Label("Next", systemImage: "chevron.right")
                }
                .disabled(currentStep >= steps.count - 1)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Cooking Steps")
    }
}

#Preview {
    NavigationStack {
        RecipeStepsView(
            instructions: """
            Chop the vegetables.
            Heat oil in a pan.
            Add vegetables and stir.
            Cook for 10 minutes.
            Serve hot.
            """
        )
    }
}
