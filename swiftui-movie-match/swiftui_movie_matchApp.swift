import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct swiftui_movie_matchApp: App {
    
  var body: some Scene {
    WindowGroup {
      
      NavigationStackManager()
      
      //      MainView(store: Store(initialState: MainFeature.State()) {
      //        MainFeature()
      //      })
      //      .onOpenURL { url in
      //        if url.host()?.lowercased() == "latestfavorite" {
      //          //FavoriteView()
      //        }
      //          print(url)
      //      }
      //    }
      //    .modelContainer(sharedModelContainer)
      
    }
    
  }
}
