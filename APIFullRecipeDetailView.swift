//
//  APIFullRecipeDetailView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import SwiftUI

struct APIFullRecipeDetailView: View {

    let mealID: String

    @State private var meal: APIMealDetail?
    @State private var isLoading = true

    var body: some View {
        ScrollView {

            if isLoading {
                ProgressView()
                    .padding()
            }

            if let meal = meal {

                if let url = URL(string: meal.strMealThumb) {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 250)
                    .clipped()
                }

                VStack(alignment: .leading, spacing: 16) {

                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .bold()

                    Text("Ingredients")
                        .font(.headline)

                    ForEach(meal.ingredients, id: \.self) { item in
                        Text("• \(item)")
                    }

                    // 🛒 BUY INGREDIENTS (API)
                    Button {
                        ShoppingManager.shared.addDish(
                            name: meal.strMeal,
                            ingredients: meal.ingredients
                        )
                    } label: {
                        Text("🛒 Buy Ingredients")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    if !meal.steps.isEmpty {
                        NavigationLink {
                            CookingStepsView(steps: meal.steps)
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
        }
        .navigationTitle("Recipe")
        .onAppear {
            fetchMealDetail()
        }
    }

    private func fetchMealDetail() {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            if let decoded = try? JSONDecoder().decode(APIMealDetailResponse.self, from: data),
               let first = decoded.meals.first {

                DispatchQueue.main.async {
                    self.meal = first
                    self.isLoading = false
                }
            }
        }.resume()
    }
}
