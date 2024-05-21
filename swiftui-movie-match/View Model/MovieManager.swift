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
      sortBy: [SortDescriptor(\.savedAt)]
    )
    favoriteMovies = (try? (context?.fetch(fetchDescriptor) ?? [])) ?? []
  }
    
  func createFavoriteMovie(_ movie: Movie) {
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
    context?.insert(favoriteMovie)
  }
  
  //MARK: - PROPERTIES
  @Published var movieCardsToShow: [Movie] = []
  var movieList: [Movie] = []
  var popularMoviePage = 3
  
  func getMovieDetail(_ id: Int) async -> MovieDetail? {
    do {
      let movieDetail = try await APIgetMovieDetail(id)
      return movieDetail
    } catch {
      print("Failed to get the movie deail (movieId:\(id)): \(error)")
      return nil
    }
  }
  
  func getPopularMovieList(_ page: Int = 2) {
    Task {
      do {
        let movieListResponse = try await APIgetPopularMovieList(page)
        
        // filter favotireMovies from incoming movies
        let favoriteMovieIds = favoriteMovies.map { $0.id }
        let newMovies = movieListResponse.results.filter { !favoriteMovieIds.contains($0.id) }
        self.movieList.append(contentsOf: newMovies)
        
        refreshMovieCardsToShow()
      } catch {
        print("Failed to get popular movies: \(error)")
      }
    }
  }
  
  func refreshMovieCardsToShow() {
    
    // add more movies to movieList
    if movieList.count < 3 {
      popularMoviePage += 1
      getPopularMovieList(self.popularMoviePage)
    }
    
    DispatchQueue.main.async {
      while self.movieCardsToShow.count < 2 {
        if(self.movieList.count == 0) { break }
        
        let movieToAdd = self.movieList.removeFirst()
        
        // Check if it's already in [FavoriteMovie]
        let favoriteMovieIds = self.favoriteMovies.map { $0.id }
        if(favoriteMovieIds.contains(movieToAdd.id)) { continue }
        
        self.movieCardsToShow.insert(movieToAdd, at: 0)
      }
    }
  }
  
  func AddMovieCardToFavorite(_ movie: Movie) {
    
    // create FavoriteMovie in SwiftData
    createFavoriteMovie(movie)
    
    // Refresh [FavoriteMovie]
    fetchFavoriteMovies()
    
    // Refresh movieCardsToShow
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
