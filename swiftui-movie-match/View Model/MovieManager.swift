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
                self.movieList.insert(movieResponse.results[2], at:0)
                self.movieList.insert(movieResponse.results[7], at:0)
              }
          } catch {
              print("Failed to fetch popular movies: \(error)")
          }
      }
  }
  
  func isTopMovieCard(_ movie: Movie) -> Bool {
    guard let index = movieList.firstIndex(where: {$0.id == movie.id}) else {
      return false
    }
    return index == movieList.count - 1
  }
}
