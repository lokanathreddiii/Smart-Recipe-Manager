//
//  RecipeCardView.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//
import SwiftUI

struct RecipeCardView: View {

    @Environment(\.managedObjectContext) private var viewContext

    // 🔥 THIS IS THE FIX
    @ObservedObject var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // IMAGE + FAVOURITE
            ZStack(alignment: .topTrailing) {

                if let data = recipe.imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .clipped()
                } else {
                    ZStack {
                        Color(.systemGray5)
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 160)
                }

                // ❤️ Favourite Button
                Button {
                    toggleFavourite()
                } label: {
                    Image(systemName: recipe.isFavourite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .padding(6)
                }
            }

            // TEXT
            VStack(alignment: .leading, spacing: 4) {

                Text(recipe.wrappedName)
                    .font(.headline)
                    .lineLimit(1)

                Text(recipe.wrappedCategory)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Label("\(recipe.cookingTime) min", systemImage: "clock")
                    .font(.caption)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(radius: 3)
    }

    private func toggleFavourite() {
        withAnimation {
            recipe.isFavourite.toggle()
            try? viewContext.save()
        }
    }
}
