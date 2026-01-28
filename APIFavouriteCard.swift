//
//  APIFavouriteCard.swift
//  SmartRecipeManager
//
//  Created by RPS on 27/01/26.
//

import SwiftUI

struct APIFavouriteCard: View {

    let meal: APIMeal
    @StateObject private var favs = APIFavouritesManager.shared

    var body: some View {
        NavigationLink {
            APIFullRecipeDetailView(mealID: meal.idMeal)
        } label: {
            VStack {
                Text(meal.strMeal)
                    .font(.headline)
                if let mealImage = meal.strMealThumb, let url = URL(string: mealImage) {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(Color(.systemGray6))
            .cornerRadius(14)
        }
        .contextMenu {
            Button(role: .destructive) {
                favs.remove(id: meal.idMeal)
            } label: {
                Label("Remove Favourite", systemImage: "heart.slash")
            }
        }
    }
}
