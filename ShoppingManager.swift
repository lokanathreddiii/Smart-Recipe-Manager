//
//  ShoppingManager.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import Foundation
import SwiftUI

struct ShoppingIngredient: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var isChecked: Bool = false
}

struct ShoppingDish: Identifiable {
    let id = UUID()
    let dishName: String
    var ingredients: [ShoppingIngredient]
}

final class ShoppingManager: ObservableObject {

    static let shared = ShoppingManager()

    @Published private(set) var dishes: [ShoppingDish] = []

    private init() {}

    // ✅ Add dish from Manual or API recipe
    func addDish(name: String, ingredients: [String]) {
        // Avoid duplicates
        if dishes.contains(where: { $0.dishName == name }) {
            return
        }

        let items = ingredients.map {
            ShoppingIngredient(name: $0)
        }

        let dish = ShoppingDish(
            dishName: name,
            ingredients: items
        )

        dishes.append(dish)
    }

    // ✅ Toggle purchased state
    func toggleIngredient(dish: ShoppingDish, ingredient: ShoppingIngredient) {
        guard
            let dishIndex = dishes.firstIndex(where: { $0.id == dish.id }),
            let ingredientIndex = dishes[dishIndex].ingredients.firstIndex(where: { $0.id == ingredient.id })
        else { return }

        dishes[dishIndex].ingredients[ingredientIndex].isChecked.toggle()
    }
}
