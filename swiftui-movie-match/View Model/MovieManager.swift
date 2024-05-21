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
  var movieCardDeck: [Movie] = []
  var popularMoviePage = 1
  
  func getMovieDetail(_ id: Int) async -> MovieDetail? {
    do {
      let movieDetail = try await APIgetMovieDetail(id)
      return movieDetail
    } catch {
      print("Failed to get the movie deail (movieId:\(id)): \(error)")
      return nil
    }
  }
  
  func getPopularMovieList() {
    Task {
      var movieListResponse: MovieResponse? = nil
      var newMovies: [Movie] = []
      
      // Repeat until movieCardDeck size is big enough
      repeat {
        do {
          movieListResponse = try await APIgetPopularMovieList(popularMoviePage)
          
          // filter favoriteMovies from incoming movies
          let favoriteMovieIds = favoriteMovies.map { $0.id }
          newMovies = movieListResponse?.results.filter { !favoriteMovieIds.contains($0.id) } ?? []
          self.movieCardDeck.append(contentsOf: newMovies)

          if movieCardDeck.count > 2 {
            updateMovieCardsToShow()
          } else {
            popularMoviePage += 1
          }
        } catch {
          print("Failed to get popular movies: \(error)")
          break
        }
      } while movieCardDeck.count <= 2
      
    }
  }
  
  func refreshPopularMovieList() {
    movieCardsToShow = []
    popularMoviePage += 1
    if movieCardDeck.count < 100 {
      DispatchQueue.main.async {
        self.getPopularMovieList()
      }
    }
  }
  
  func updateMovieCardsToShow() {
    // Always show 2 movie cards on the screen
    movieCardDeck.shuffle()
    DispatchQueue.main.async {
      while self.movieCardsToShow.count < 2 {
        if(self.movieCardDeck.count == 0) { break }
        
        let movieToAdd = self.movieCardDeck.removeFirst()
                
        self.movieCardsToShow.insert(movieToAdd, at: 0)
      }
    }
  }
  
  func AddMovieCardToFavorite(_ movie: Movie) {
    
    // create FavoriteMovie in SwiftData
    createFavoriteMovie(movie)
    
    // Refresh [FavoriteMovie]
    fetchFavoriteMovies()
    
    // Remove the duplicate from CardDeck
    movieCardDeck.removeAll { $0.id == movie.id }
        
    // Refresh movieCardsToShow
    _ = movieCardsToShow.popLast()
    updateMovieCardsToShow()
  }
  
  func RemoveMovieCard(_ movie: Movie) {
    // Refresh movieCardsToShow
    _ = movieCardsToShow.popLast()
    updateMovieCardsToShow()
  }
  
  func isTopMovieCard(_ movie: Movie) -> Bool {
    guard let index = movieCardsToShow.firstIndex(where: {$0.id == movie.id}) else {
      return false
    }
    return index == (movieCardsToShow.count - 1)
  }
}
