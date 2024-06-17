//
//  NavigationStackManager.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

enum NavRoute {
  case mainView
  case favoriteView
  case settingsView
  case detailView
}

struct NavigationStackManager: View {
  //MARK: - Navigation Stack
  @State var navStack = [NavRoute]()
  
  //MARK: - SwiftData
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
  
  //MARK: - BODY
  var body: some View {
    NavigationStack(path:$navStack) {
      
      // Root View
      MainView(store: Store(initialState: MainFeature.State()) {
        MainFeature()
      }, navStack: $navStack)
      .modelContainer(sharedModelContainer)
      .navigationDestination(for: NavRoute.self) { route in
        switch(route) {
          
        //MARK: - MAIN VIEW
        case .mainView:
          MainView(store: Store(initialState: MainFeature.State()) {
            MainFeature()
          }, navStack: $navStack)
          .modelContainer(sharedModelContainer)
          
        //MARK: - SETTINGS VIEW
        case .settingsView:
          SettingsView(navStack: $navStack,
                       store: Store(initialState: SettingsFeature.State()) { SettingsFeature() })
          
        //MARK: - FAVORITE VIEW
        case .favoriteView:
          FavoriteView(navStack: $navStack)
            .modelContainer(sharedModelContainer)
          
        //MARK: - DETAIL VIEW
        case .detailView:
          let sampleFavoriteMovie: FavoriteMovie = FavoriteMovie(
            id: 823464,
            releaseDate: "2024-03-27",
            title: "Godzilla x Kong: The New Empire",
            originalTitle: "Godzilla x Kong: The New Empire",
            overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
            voteAverage: 7.222,
            savedAt: Date.now,
            language: "en")
          
          DetailView(navStack: $navStack,
                     favoriteMovie: sampleFavoriteMovie)
          .modelContainer(sharedModelContainer)
          
        }
      }
      
    }
  }
}

#Preview {
  NavigationStackManager()
}
