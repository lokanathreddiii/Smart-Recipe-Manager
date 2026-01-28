//
//  CookingStepsView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import SwiftUI

struct CookingStepsView: View {

    let steps: [String]
    @State private var currentStep = 0

    var body: some View {
        Group {
            if steps.isEmpty {
                Text("No cooking steps available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(spacing: 24) {

                    ProgressView(
                        value: Double(currentStep + 1),
                        total: Double(steps.count)
                    )
                    .padding(.horizontal)

                    Text("Step \(currentStep + 1) of \(steps.count)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text(steps[currentStep])
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()

                    HStack {

                        Button("Previous") {
                            if currentStep > 0 {
                                currentStep -= 1
                            }
                        }
                        .disabled(currentStep == 0)

                        Spacer()

                        Button("Next") {
                            if currentStep < steps.count - 1 {
                                currentStep += 1
                            }
                        }
                        .disabled(currentStep == steps.count - 1)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationTitle("Cooking Steps")
    }
}
