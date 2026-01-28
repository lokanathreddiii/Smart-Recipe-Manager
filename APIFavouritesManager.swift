//
//  APIFavouritesManager.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import Foundation
import SwiftUI

final class APIFavouritesManager: ObservableObject {

    static let shared = APIFavouritesManager()

    // Dictionary for fast lookup
    @Published private(set) var favouriteMeals: [String: APIMeal] = [:]

    private let key = "api_favourite_meals"

    private init() {
        load()
    }

    // MARK: - Public API

    func toggle(meal: APIMeal) {
        if favouriteMeals[meal.idMeal] != nil {
            favouriteMeals.removeValue(forKey: meal.idMeal)
        } else {
            favouriteMeals[meal.idMeal] = meal
        }
        save()
    }

    func remove(id: String) {
        favouriteMeals.removeValue(forKey: id)
        save()
    }

    func isFavourite(id: String) -> Bool {
        favouriteMeals[id] != nil
    }

    // MARK: - Persistence

    private func save() {
        // Convert dictionary → array before encoding
        let mealsArray = Array(favouriteMeals.values)

        do {
            let data = try JSONEncoder().encode(mealsArray)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save API favourites:", error)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let meals = try? JSONDecoder().decode([APIMeal].self, from: data)
        else {
            return
        }

        // Convert array → dictionary
        favouriteMeals = Dictionary(
            uniqueKeysWithValues: meals.map { ($0.idMeal, $0) }
        )
    }
}
