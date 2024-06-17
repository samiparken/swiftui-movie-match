//
//  NavigationStackManager.swift
//  swiftui-movie-match
//
//  Created by Han-Saem Park on 2024-06-17.
//

import SwiftUI
import SwiftData
import Observation
import ComposableArchitecture

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
  
  //MARK: - PROPERTIES
  private var movieManager = MovieManager()
  
  //MARK: - BODY
  var body: some View {
    NavigationStack(path:$navStack) {
      
      // Root View
      MainView(store: Store(initialState: MainFeature.State()) {
        MainFeature()
      }, navStack: $navStack, movieManager: movieManager)
      .modelContainer(sharedModelContainer)
      .navigationDestination(for: NavRoute.self) { route in
        switch(route) {
          
        //MARK: - MAIN VIEW
        case .mainView:
          MainView(store: Store(initialState: MainFeature.State()) {
            MainFeature()
          }, navStack: $navStack, movieManager: movieManager)
          .modelContainer(sharedModelContainer)
          .navigationBarBackButtonHidden()
          
        //MARK: - SETTINGS VIEW
        case .settingsView:
          SettingsView(navStack: $navStack,
                       store: Store(initialState: SettingsFeature.State()) { SettingsFeature() })
          .navigationBarBackButtonHidden()
          
        //MARK: - FAVORITE VIEW
        case .favoriteView:
          FavoriteView(navStack: $navStack, movieManager: movieManager)
            .modelContainer(sharedModelContainer)
            .navigationBarBackButtonHidden()

          
        //MARK: - DETAIL VIEW
        case .detailView:
          let movie = movieManager.selectedFavoriteMovie ?? SampleData.favoriteMovie
          
          DetailView(navStack: $navStack,
                     movieManager: movieManager,
                     favoriteMovie: movie)
          .modelContainer(sharedModelContainer)
          .navigationBarBackButtonHidden()
        }
      }
      
    }    
  }
}

#Preview {
  NavigationStackManager()
}
