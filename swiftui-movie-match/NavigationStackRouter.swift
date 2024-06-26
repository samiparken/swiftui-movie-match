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

@Reducer
struct RootFeature {
  //MARK: - State
  @ObservableState
  struct State: Equatable {
        
  }
  
  //MARK: - Action
  enum Action {
    
  }
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

struct NavigationStackRouter: View {
  //MARK: - TCA store
  @Bindable var store: StoreOf<RootFeature>
  
  //MARK: - Navigation Stack
  @State var navStack = [NavRoute]()
  
  //MARK: - SwiftData
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([FavoriteMovie.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  //MARK: - PROPERTIES
  private var movieManager = MovieManager()
  
  //MARK: - INIT
  init(store: StoreOf<RootFeature>) {
    self.store = store
  }
  
  //MARK: - BODY
  var body: some View {
    NavigationStack(path: $navStack) {
      
      //MARK: - ROOT VIEW
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
          FavoriteView(store: Store(initialState: FavoriteFeature.State()){
            FavoriteFeature()
          }, navStack: $navStack, movieManager: movieManager)
          .modelContainer(sharedModelContainer)
          .navigationBarBackButtonHidden()
          
        //MARK: - DETAIL VIEW
        case .detailView:
          let movie = movieManager.selectedFavoriteMovie ?? SampleData.favoriteMovie
          
          DetailView(store: Store(initialState: DetailFeature.State()){
            DetailFeature()
          }, 
                     navStack: $navStack,
                     movieManager: movieManager,
                     favoriteMovie: movie)
          .modelContainer(sharedModelContainer)
          .navigationBarBackButtonHidden()
        }
      }
    }
    .onOpenURL { url in
      handleDeepLink(from: url)
    }
    
  }
}

//MARK: - DEEP LINK
extension NavigationStackRouter {
  func handleDeepLink(from url: URL) {
    let host = url.host()?.lowercased()
    switch(host) {
            
    //MARK: - MAIN VIEW
    case K.DeepLink.Host.mainView:
      navStack.removeAll()
      
    //MARK: - DETAIL VIEW with movieId
    case K.DeepLink.Host.movieDetail:
      let movieId = Int(url.pathComponents[1]) ?? 0
      navStack.removeAll()
      navStack.append(.favoriteView)
      if movieManager.selectFavoriteMovie(id: movieId) {
        navStack.append(.detailView)
      }
      
    default: 
      break
    }
  }
}

//MARK: - PREVIEW
#Preview {
  NavigationStackRouter(
    store: Store(initialState: RootFeature.State()) {
    RootFeature()
  })
  .modelContainer(for: FavoriteMovie.self, inMemory: true)
}
