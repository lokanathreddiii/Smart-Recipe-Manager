
import SwiftUI

struct ContentView: View {

    init() {
        // 🔥 FORCE WHITE TAB BAR BACKGROUND
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            TabView {

                RecipeListView()
                    .tabItem {
                        Label("Recipes", systemImage: "list.bullet")
                    }

                FavouritesView()
                    .tabItem {
                        Label("Favourites", systemImage: "heart.fill")
                    }

                AddRecipeView()
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }

                ShoppingListView()
                    .tabItem {
                        Label("Shopping", systemImage: "cart.fill")
                    }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            // 🔥 ENSURE TAB BAR STAYS WHITE
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.white, for: .tabBar)
        }
    }
}
