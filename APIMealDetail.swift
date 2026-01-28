//
//  APIMealDetail.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import Foundation

struct APIMealDetailResponse: Decodable {
    let meals: [APIMealDetail]
}

struct APIMealDetail: Decodable {

    let strMeal: String
    let strInstructions: String
    let strMealThumb: String

    // INGREDIENTS (API gives many optionals)
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?

    // ✅ CLEAN INGREDIENT LIST
    var ingredients: [String] {
        [
            strIngredient1,
            strIngredient2,
            strIngredient3,
            strIngredient4,
            strIngredient5,
            strIngredient6,
            strIngredient7,
            strIngredient8,
            strIngredient9,
            strIngredient10
        ]
        .compactMap { $0 }
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    }

    // ✅ FIXED STEP LOGIC (THIS SOLVES YOUR ISSUE 🔥)
    var steps: [String] {
        strInstructions
            .replacingOccurrences(of: "\r", with: "")
            .components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .enumerated()
            .map { "Step \($0.offset + 1): \($0.element)" }
    }
}
