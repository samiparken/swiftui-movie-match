import SwiftUI
import Combine

class MovieManager: ObservableObject {
  
  //MARK: - PROPERTIES
  @Published var movieCardsToShow: [Movie] = []
  var movieList: [Movie] = []
  
  init() {
    fetchPopularMovieList()
  }
  
  func fetchPopularMovieList() {
    Task {
      do {
        //+TODO: get movie list dynamically
        let movieListResponse = try await APIgetPopularMovieList(1)
        self.movieList = movieListResponse.results
        self.refreshMovieCardsToShow()
      } catch {
        print("Failed to fetch popular movies: \(error)")
      }
    }
  }
  
  func refreshMovieCardsToShow() {
    DispatchQueue.main.async {
      while self.movieCardsToShow.count < 2 {
        if self.movieList.count == 0 { return }
        let movieToAdd = self.movieList.removeFirst()
        self.movieCardsToShow.insert(movieToAdd, at: 0)
      }
    }
  }
  
  func AddMovieCardToFavorite(_ movie: Movie) {
    _ = movieCardsToShow.popLast()
    refreshMovieCardsToShow()
  }
  
  func RemoveMovieCard(_ movie: Movie) {
    _ = movieCardsToShow.popLast()
    refreshMovieCardsToShow()
  }
  
  func isTopMovieCard(_ movie: Movie) -> Bool {
    guard let index = movieCardsToShow.firstIndex(where: {$0.id == movie.id}) else {
      return false
    }
    return index == (movieCardsToShow.count - 1)
  }
}
