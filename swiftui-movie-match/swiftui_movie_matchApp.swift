import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct swiftui_movie_matchApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
          FavoriteMovie.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView(store: Store(initialState: MainFeature.State()) {
              MainFeature()
            })
        }
        .modelContainer(sharedModelContainer)
    }
}
