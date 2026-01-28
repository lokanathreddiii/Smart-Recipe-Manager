//
//
import SwiftUI

struct ShoppingListView: View {

    @StateObject private var shopping = ShoppingManager.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(shopping.dishes) { dish in
                    Section {
                        ForEach(dish.ingredients) { ingredient in
                            HStack {
                                Button {
                                    shopping.toggleIngredient(
                                        dish: dish,
                                        ingredient: ingredient
                                    )
                                } label: {
                                    Image(systemName: ingredient.isChecked
                                          ? "checkmark.circle.fill"
                                          : "circle")
                                        .foregroundColor(
                                            ingredient.isChecked ? .green : .gray
                                        )
                                }

                                Text(" \(ingredient.name)")
                                    .strikethrough(ingredient.isChecked)
                                    .foregroundColor(
                                        ingredient.isChecked ? .gray : .primary
                                    )
                            }
                        }
                    } header: {
                        Text(dish.dishName)
                            .font(.title3)
                            .bold()
                            .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Shopping List")
        }
    }
}
