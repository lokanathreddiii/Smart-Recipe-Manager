//
//  Recipe+Extensions.swift
//  SmartRecipeManager
//
//  Created by RPS on 22/01/26.
//
import Foundation
import CoreData

extension Recipe {

    // MARK: - Safe unwraps for SwiftUI

    var wrappedName: String {
        name ?? "Untitled Recipe"
    }

    var wrappedIngredients: String {
        ingredients ?? ""
    }

    var wrappedInstructions: String {
        instructions ?? ""
    }

    var wrappedCategory: String {
        category ?? "General"
    }

    var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    // MARK: - Sample Data (for preview & testing)

    static var example: Recipe {
        let context = PersistenceController.shared.container.viewContext
        let recipe = Recipe(context: context)
        recipe.id = UUID()
        recipe.name = "Sample Recipe"
        recipe.ingredients = "Salt, Sugar, Oil"
        recipe.instructions = "Mix everything and cook well."
        recipe.cookingTime = 30
        recipe.difficulty = 2.5
        recipe.category = "General"
        recipe.isFavourite = false
        recipe.createdAt = Date()
        return recipe
    }
}
