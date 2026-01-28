
private var filteredRecipes: [Recipe] {
    recipes.filter { recipe in

        // Always show all
        if selectedCategory == "All" {
            return true
        }

        let category = recipe.category?.lowercased() ?? ""

        // Veg logic
        if selectedCategory == "Veg" {
            return category.contains("veg")
                || category.contains("vegetarian")
                || category.isEmpty        // 👈 OLD RECIPES SAFETY
        }

        // Non-Veg logic
        if selectedCategory == "Non-Veg" {
            return category.contains("non")
                || category.contains("chicken")
                || category.contains("mutton")
                || category.contains("beef")
                || category.contains("fish")
        }

        return false  // If no condition matches, hide this recipe
    }
}
