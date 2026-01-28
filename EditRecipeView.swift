//
//  EditRecipeView.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//

import SwiftUI

struct EditRecipeView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var recipe: Recipe

    @State private var name: String
    @State private var ingredients: String
    @State private var instructions: String
    @State private var cookingTime: Int
    @State private var difficulty: Double
    @State private var isFavourite: Bool
    @State private var category: RecipeCategory
    @State private var selectedImage: UIImage?

    init(recipe: Recipe) {
        self.recipe = recipe
        _name = State(initialValue: recipe.wrappedName)
        _ingredients = State(initialValue: recipe.ingredients ?? "")
        _instructions = State(
            initialValue: recipe.instructions?
                .replacingOccurrences(
                    of: #"Step \d+:\s*"#,
                    with: "",
                    options: .regularExpression
                ) ?? ""
        )
        _cookingTime = State(initialValue: Int(recipe.cookingTime))
        _difficulty = State(initialValue: recipe.difficulty)
        _isFavourite = State(initialValue: recipe.isFavourite)
        _category = State(
            initialValue: RecipeCategory(rawValue: recipe.wrappedCategory) ?? .veg
        )

        if let data = recipe.imageData,
           let img = UIImage(data: data) {
            _selectedImage = State(initialValue: img)
        } else {
            _selectedImage = State(initialValue: nil)
        }
    }

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

                // INSTRUCTIONS
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
            .navigationTitle("Edit Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") { updateRecipe() }
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

    private func updateRecipe() {
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = formatSteps(instructions)
        recipe.cookingTime = Int16(cookingTime)
        recipe.difficulty = difficulty
        recipe.isFavourite = isFavourite
        recipe.category = category.rawValue

        if let image = selectedImage {
            recipe.imageData = image.jpegData(compressionQuality: 0.8)
        }

        try? viewContext.save()
        dismiss()
    }
}
