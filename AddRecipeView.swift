//
//  AddRecipeView.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//

import SwiftUI

struct AddRecipeView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var cookingTime = 30
    @State private var difficulty = 2.5
    @State private var isFavourite = false
    @State private var category: RecipeCategory = .veg
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            Form {

                // IMAGE
                Section(header: Text("Recipe Image")) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                // BASIC INFO
                Section(header: Text("Recipe Info")) {
                    TextField("Recipe Name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(RecipeCategory.savableCategories) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }

                    Toggle("Mark as Favourite", isOn: $isFavourite)
                }

                // INGREDIENTS
                Section(header: Text("Ingredients")) {
                    TextEditor(text: $ingredients)
                        .frame(height: 80)
                }

                // INSTRUCTIONS (STEP BY STEP)
                Section(header: Text("Instructions")) {
                    ZStack(alignment: .topLeading) {

                        if instructions.isEmpty {
                            Text("""
Step 1: Take a pan
Step 2: Add water
Step 3: Add ingredients
Step 4: Cook for 10 minutes
Step 5: Serve hot
""")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                        }

                        TextEditor(text: $instructions)
                            .frame(height: 140)
                    }
                }

                // COOKING DETAILS
                Section(header: Text("Cooking Details")) {
                    Stepper("Cooking Time: \(cookingTime) min",
                            value: $cookingTime,
                            in: 1...300)

                    VStack(alignment: .leading) {
                        Text("Difficulty: \(difficulty, specifier: "%.1f")")
                        Slider(value: $difficulty, in: 1...5, step: 0.5)
                    }
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveRecipe() }
                        .disabled(name.isEmpty || instructions.isEmpty)
                }
            }
        }
    }

    // 🔥 AUTO STEP FORMAT
    private func formatSteps(_ text: String) -> String {
        let lines = text
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        return lines.enumerated().map { index, line in
            "Step \(index + 1): \(line)"
        }
        .joined(separator: "\n")
    }

    private func saveRecipe() {
        let recipe = Recipe(context: viewContext)
        recipe.id = UUID()
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = formatSteps(instructions)
        recipe.cookingTime = Int16(cookingTime)
        recipe.difficulty = difficulty
        recipe.category = category.rawValue
        recipe.isFavourite = isFavourite
        recipe.createdAt = Date()

        if let image = selectedImage {
            recipe.imageData = image.jpegData(compressionQuality: 0.8)
        }

        try? viewContext.save()
        dismiss()
    }
}
