//
//  NavigationStackManager.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

enum Routes {
  case mainView
  case favoriteView
  case settingsView
  case detailView
}

struct NavigationStackManager: View {
  //MARK: - Navigation Stack
  @State var navStack = [Routes]()

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
      .navigationDestination(for: Routes.self) { r in
        switch(r) {
          
        case .mainView:
          MainView(store: Store(initialState: MainFeature.State()) {
            MainFeature()
          }, navStack: $navStack)
          .modelContainer(sharedModelContainer)

        case .settingsView:
          SettingsView(navStack: $navStack,
                       store: Store(initialState: SettingsFeature.State()) { SettingsFeature() })
          
        case .favoriteView:
          FavoriteView(navStack: $navStack)
            .modelContainer(sharedModelContainer)
                    
        case .detailView:
          DetailView(movieId: 823464, languageCode: "en")
            .modelContainer(sharedModelContainer)
                    
        }
      }
      
    }
  }
}

#Preview {
  NavigationStackManager()
}
