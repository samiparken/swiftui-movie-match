import Foundation
import SwiftUI
import SwiftData
import Observation

class MovieManager: ObservableObject {
  //MARK: - SwiftData
  var context: ModelContext? = nil
  var favoriteMovies: [FavoriteMovie] = []

  func fetchFavoriteMovies() {
    let fetchDescriptor = FetchDescriptor<FavoriteMovie>(
      predicate: #Predicate {
        $0.title != ""
      },
      sortBy: [SortDescriptor(\.title)]
    )
    favoriteMovies = (try? (context?.fetch(fetchDescriptor) ?? [])) ?? []
  }
  
  //MARK: - PROPERTIES
  @Published var movieCardsToShow: [Movie] = []
  var movieList: [Movie] = []
  
  init() {
    getPopularMovieList()
  }
  
  func getPopularMovieList() {
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
    
    // Create a new FavoriteMovie instance
    let favoriteMovie = FavoriteMovie(
      id: movie.id,
      posterPath: movie.posterPath,
      releaseDate: movie.releaseDate,
      title: movie.title,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      voteAverage: movie.voteAverage,
      savedAt: Date()
    )
    
    // Insert the new FavoriteMovie into the model context
    context?.insert(favoriteMovie)
    try? context?.save()
    
    //Refresh
    fetchFavoriteMovies()
    
    //Refresh movieCardsToShow
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
