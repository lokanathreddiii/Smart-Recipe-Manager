
import SwiftUI
import CoreData

struct RecipeListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    // MARK: - CORE DATA (MANUAL RECIPES)
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.createdAt, ascending: false)],
        animation: .default
    )
    private var recipes: FetchedResults<Recipe>

    // MARK: - API RECIPES
    @State private var apiMeals: [APIMeal] = []

    // MARK: - UI STATE
    @State private var selectedCategory: String = "All"

    private let categories = ["All", "Veg", "Non-Veg"]

    // MARK: - FILTER MANUAL RECIPES
    private var filteredManualRecipes: [Recipe] {
        recipes.filter { recipe in
            if selectedCategory == "All" { return true }

            let category = recipe.category?.lowercased() ?? ""

            if selectedCategory == "Veg" {
                return category.contains("veg")
                    || category.contains("vegetarian")
                    || category.isEmpty
            }

            if selectedCategory == "Non-Veg" {
                return category.contains("non")
                    || category.contains("chicken")
                    || category.contains("mutton")
                    || category.contains("fish")
                    || category.contains("beef")
            }

            return true
        }
    }

    // MARK: - FILTER API RECIPES
    private var filteredAPIMeals: [APIMeal] {
        if selectedCategory == "All" { return apiMeals }

        if selectedCategory == "Veg" {
            return apiMeals.filter {
                $0.strMeal.lowercased().contains("veg")
                || $0.strMeal.lowercased().contains("paneer")
                || $0.strMeal.lowercased().contains("dal")
            }
        }

        if selectedCategory == "Non-Veg" {
            return apiMeals.filter {
                $0.strMeal.lowercased().contains("chicken")
                || $0.strMeal.lowercased().contains("mutton")
                || $0.strMeal.lowercased().contains("fish")
            }
        }

        return apiMeals
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {

                // 🔹 CATEGORY BAR (NOW INSIDE MAIN SCROLL)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                Text(category)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == category
                                        ? Color.blue
                                        : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        selectedCategory == category
                                        ? .white
                                        : .primary
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                // 🔹 RECIPE GRID
                LazyVGrid(columns: columns, spacing: 16) {

                    // MANUAL RECIPES
                    ForEach(filteredManualRecipes, id: \.objectID) { recipe in
                        UnifiedRecipeCardView(recipe: .local(recipe))
                    }

                    // API RECIPES
                    ForEach(filteredAPIMeals) { meal in
                        UnifiedRecipeCardView(recipe: .api(meal))
                    }
                }
                .padding()
            }
            .navigationTitle("Recipes")
            .task {
                await loadAPIRecipes()
            }
        }
    }

    // MARK: - API FETCH
    private func loadAPIRecipes() async {
        guard apiMeals.isEmpty else { return }
        do {
            apiMeals = try await RecipeAPIService.shared.fetchRecipes()
        } catch {
            print("❌ API ERROR:", error)
        }
    }
}
