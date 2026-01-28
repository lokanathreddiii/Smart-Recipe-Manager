
import SwiftUI
import CoreData

enum UnifiedRecipe {
    case local(Recipe)
    case api(APIMeal)
}

struct UnifiedRecipeCardView: View {

    let recipe: UnifiedRecipe

    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var apiFavs = APIFavouritesManager.shared
    @State private var showDeleteDialog = false

    var body: some View {
        NavigationLink {
            destinationView
        } label: {
            cardView
        }
        .buttonStyle(.plain)

        // ✅ CONTEXT MENU (LONG PRESS WITHOUT BLOCKING SCROLL)
        .contextMenu {
            Button(role: .destructive) {
                showDeleteDialog = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }

        // ✅ DELETE CONFIRMATION
        .confirmationDialog(
            "Delete Recipe?",
            isPresented: $showDeleteDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                deleteRecipe()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - CARD UI
    private var cardView: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {

                image
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)

                Text(title)
                    .font(.headline)
                    .lineLimit(1)

                Text("Indian")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 3)
            .contentShape(Rectangle())

            // ❤️ Favourite button (manual + API)
            Button {
                toggleFavourite()
            } label: {
                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding(6)
            }
        }
    }

    // MARK: - IMAGE
    private var image: some View {
        ZStack {
            Color(.systemGray5)

            switch recipe {
            case .local(let r):
                if let data = r.imageData,
                   let img = UIImage(data: data) {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                }

            case .api(let api):
                if let urlStr = api.strMealThumb,
                   let url = URL(string: urlStr) {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
    }

    // MARK: - DESTINATION
    @ViewBuilder
    private var destinationView: some View {
        switch recipe {
        case .local(let recipe):
            RecipeDetailView(recipe: recipe)
        case .api(let api):
            APIFullRecipeDetailView(mealID: api.idMeal)
        }
    }

    // MARK: - FAVOURITES
    private var isFavourite: Bool {
        switch recipe {
        case .local(let r): return r.isFavourite
        case .api(let a): return apiFavs.isFavourite(id: a.idMeal)
        }
    }

    private func toggleFavourite() {
        switch recipe {
        case .local(let r):
            r.isFavourite.toggle()
            try? viewContext.save()
        case .api(let a):
            apiFavs.toggle(meal: a)
        }
    }

    // MARK: - DELETE
    private func deleteRecipe() {
        switch recipe {
        case .local(let r):
            viewContext.delete(r)
            try? viewContext.save()
        case .api(let a):
            apiFavs.remove(id: a.idMeal)
        }
    }

    private var title: String {
        switch recipe {
        case .local(let r): return r.wrappedName
        case .api(let a): return a.strMeal ?? "Unknown Recipe"
        }
    }
}
