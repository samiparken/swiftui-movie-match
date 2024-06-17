import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct swiftui_movie_matchApp: App {
    
  var body: some Scene {
    WindowGroup {
      NavigationStackRouter()
    }
  }
}
