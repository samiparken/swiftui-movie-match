import SwiftUI
import Combine

class MovieManager: ObservableObject {
    
  //MARK: - PROPERTIES
  @Published var movieList: [Movie] = []
  
  init() {
    fetchPopularMovieList()
  }
  
  func fetchPopularMovieList() {
      Task {
          do {
              let movieResponse = try await APIgetPopularMovieList(1)
              DispatchQueue.main.async {
                  self.movieList.append(movieResponse.results[2])
                  self.movieList.append(movieResponse.results[3])
              }
          } catch {
              print("Failed to fetch popular movies: \(error)")
          }
      }
  }
}
