//
//  RecipeDetailView.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//
import SwiftUI

struct RecipeDetailView: View {

    let recipe: Recipe
    @State private var showEdit = false

    var body: some View {
        ScrollView {

            if let data = recipe.imageData,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 16) {

                Text(recipe.wrappedName)
                    .font(.largeTitle)
                    .bold()

                // INGREDIENTS
                Text("Ingredients")
                    .font(.headline)

                ForEach(ingredients, id: \.self) { item in
                    Text("• \(item)")
                }

                // 🛒 BUY INGREDIENTS (MANUAL)
                Button {
                    ShoppingManager.shared.addDish(
                        name: recipe.wrappedName,
                        ingredients: ingredients
                    )
                } label: {
                    Text("🛒 Buy Ingredients")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // START COOKING
                if !steps.isEmpty {
                    NavigationLink {
                        CookingStepsView(steps: steps)
                    } label: {
                        Text("Start Cooking")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Recipe")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEdit = true
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditRecipeView(recipe: recipe)
        }
    }

    // MARK: - INGREDIENTS
    private var ingredients: [String] {
        guard let raw = recipe.ingredients else { return [] }

        return raw
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    // MARK: - STEPS
    private var steps: [String] {
        guard let raw = recipe.instructions else { return [] }

        return raw
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
