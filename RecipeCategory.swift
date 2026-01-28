//
//  RecipeCategory.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import SwiftUI

enum RecipeCategory: String, CaseIterable, Identifiable {

    case all = "All"
    case veg = "Veg"
    case nonVeg = "Non-Veg"
    case dessert = "Dessert"
    case sweet = "Sweet"
    case juice = "Juice"
    case snack = "Snack"
    case breakfast = "Breakfast"
    case dinner = "Dinner"

    var id: String { rawValue }

    // Categories allowed to SAVE in Core Data
    static var savableCategories: [RecipeCategory] {
        RecipeCategory.allCases.filter { $0 != .all }
    }
}
