//
//  RecipeWidget.swift
//  RecipeWidget
//
//  Created by RPS on 22/01/26.
//
import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct RecipeEntry: TimelineEntry {
    let date: Date
    let recipeName: String
    let subtitle: String
}

// MARK: - Provider
struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> RecipeEntry {
        RecipeEntry(
            date: Date(),
            recipeName: "Maggi",
            subtitle: "Quick & Easy Recipe"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (RecipeEntry) -> Void) {
        let entry = RecipeEntry(
            date: Date(),
            recipeName: "Maggi",
            subtitle: "Ready in 10 minutes"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RecipeEntry>) -> Void) {

        let recipes = [
            ("Maggi", "Quick & Easy"),
            ("Pasta", "Italian Delight"),
            ("Veg Fried Rice", "Healthy & Tasty"),
            ("Paneer Curry", "Rich & Spicy"),
            ("Omelette", "Protein Boost")
        ]

        let random = recipes.randomElement() ?? ("Recipe", "Try something new")

        let entry = RecipeEntry(
            date: Date(),
            recipeName: random.0,
            subtitle: random.1
        )

        // Update every 6 hours
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget View
struct RecipeWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("🍽 Recipe of the Day")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(entry.recipeName)
                .font(.headline)
                .bold()

            Text(entry.subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Widget

struct RecipeWidget: Widget {
    let kind: String = "RecipeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            RecipeWidgetView(entry: entry)
        }
        .configurationDisplayName("Recipe of the Day")
        .description("Discover a new recipe every day.")
        .supportedFamilies([.systemSmall])
    }
}
