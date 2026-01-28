
//
//  FavouritesView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
//
import SwiftUI
import CoreData

struct FavouritesView: View {

    // 🔹 CORE DATA CONTEXT
    @Environment(\.managedObjectContext) private var viewContext

    // 🔹 MANUAL FAVOURITES (CORRECT ENTITY)
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.createdAt, ascending: false)],
        predicate: NSPredicate(format: "isFavourite == YES"),
        animation: .default
    )
    private var manualFavourites: FetchedResults<Recipe>

    // 🔹 API FAVOURITES
    @StateObject private var apiFavs = APIFavouritesManager.shared

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // ✅ UNIFIED FAVOURITES GRID (NO DIFFERENCE)
                    if !manualFavourites.isEmpty || !apiFavs.favouriteMeals.isEmpty {

                        LazyVGrid(columns: columns, spacing: 16) {

                            // 🔹 MANUAL RECIPES
                            ForEach(manualFavourites) { recipe in
                                UnifiedRecipeCardView(recipe: .local(recipe))
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteManual(recipe)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }

                            // 🔹 API RECIPES
                            ForEach(
                                Array(apiFavs.favouriteMeals.values),
                                id: \.idMeal
                            ) { meal in
                                UnifiedRecipeCardView(recipe: .api(meal))
                            }
                        }
                        .padding(.horizontal)
                    }

                    // EMPTY STATE
                    if manualFavourites.isEmpty && apiFavs.favouriteMeals.isEmpty {
                        ContentUnavailableView(
                            "No Favourites",
                            systemImage: "heart",
                            description: Text("Tap ❤️ or long-press a recipe to favourite it.")
                        )
                        .padding(.top, 60)
                    }
                }
            }
            .navigationTitle("Favourites")
        }
    }

    // 🔥 DELETE MANUAL RECIPE
    private func deleteManual(_ recipe: Recipe) {
        viewContext.delete(recipe)
        try? viewContext.save()
    }
}
