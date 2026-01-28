🍽️ SmartRecipeManager

SmartRecipeManager is an iOS application built using SwiftUI that helps users manage recipes in an organized and simple way. The app supports both manually added recipes and online recipes fetched from an external API. Users can save favourites, generate a shopping list from ingredients, and follow step-by-step cooking instructions.

This project focuses on combining local data storage with online content while maintaining a clean and user-friendly experience.

✨ Features

📋 Recipe Management  
Users can add recipes manually by entering the recipe name, ingredients, and cooking steps. Online recipes fetched from the API are displayed alongside manual recipes in a unified layout.

🌐 Online Recipes  
Recipes are fetched from TheMealDB API and include images, ingredients, and instructions. API recipes behave the same as manual recipes inside the app.

❤️ Favourites  
Both manual and API recipes can be marked as favourites. All favourites are shown together in a single favourites screen.

🛒 Buy Ingredients (Shopping List)  
Ingredients from any recipe can be added to a shopping list.  
Ingredients are grouped under the respective dish name.  
Purchased items can be marked and struck off.  
Duplicate dishes are avoided in the shopping list.

🔍 Filtering  
Recipes can be filtered by category such as All, Veg, and Non-Veg for easier browsing.

🗑️ Delete and Manage  
Recipes can be deleted using a long-press context menu with confirmation to prevent accidental deletion.

🛠️ Technology Used

- Language: Swift  
- Framework: SwiftUI  
- Architecture: MVVM (lightweight)  
- Persistence: Core Data (manual recipes)  
- API: TheMealDB  
- State Management: ObservableObject, State, StateObject  

🚀 How to Run the Project

Open the project in Xcode.  
Select an iOS simulator or a connected iPhone.  
Run the project using the Run button.  
Internet connection is required to load online recipes.

📂 Project Structure (Key Files)

- RecipeListView.swift – Main recipe listing and filtering  
- UnifiedRecipeCardView.swift – Shared UI for manual and API recipes  
- RecipeDetailView.swift – Manual recipe details  
- APIFullRecipeDetailView.swift – API recipe details  
- ShoppingManager.swift – Shopping list data handling  
- ShoppingListView.swift – Shopping list UI  
- APIFavouritesManager.swift – API favourites handling  

🔮 Future Improvements

- Persist shopping list across app restarts  
- Add ingredient quantities and prices  
- Add recipe search  
- Improve UI animations  

👨‍💻 Author

Baana Lokhanath Reddy  
 

📜 License

This project is licensed under the MIT License.  
See the LICENSE file for more details.
