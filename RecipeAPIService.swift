//
//  RecipeAPIService.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import Foundation

final class RecipeAPIService {

    static let shared = RecipeAPIService()
    private init() {}

    func fetchRecipes() async throws -> [APIMeal] {

        let urlString =
        "https://www.themealdb.com/api/json/v1/1/filter.php?a=Indian"

        guard let url = URL(string: urlString) else { return [] }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(APIMealResponse.self, from: data)

        return decoded.meals ?? []
    }
}
