import Foundation
import SwiftUI

class MovieManager: ObservableObject {
  
  @Published var movieList: [Movie]?
  
  init() {
    fetchPopularMovieList()
  }
  
  func fetchPopularMovieList() {
    Task {
      do {
        let movieResponse = try await APIgetPopularMovieList(1)
        movieList = movieResponse.results
      } catch {
        print("Failed to fetch popular movies: \(error)")
      }
    }
  }
}
