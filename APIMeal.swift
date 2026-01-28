//
//  APIMeal.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import Foundation

struct APIMealResponse: Decodable {
    let meals: [APIMeal]
}

struct APIMeal: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String?

    var id: String { idMeal }
}
