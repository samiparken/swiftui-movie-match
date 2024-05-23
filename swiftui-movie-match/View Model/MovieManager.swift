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
      savedAt: Date(),
      language: currentLanguage
    )
    context?.insert(favoriteMovie)
  }
  
  //MARK: - PROPERTIES
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  @Published var movieCardsToShow: [Movie] = []
  var movieCardDeck: [Movie] = []
  var popularMoviePage = 1
  var currentLanguage = LocaleIdentifier.English.rawValue
  
  func getMovieDetail(id: Int, languageCode: String) async -> MovieDetail? {
    guard let movieDetail = try? await APIgetMovieDetail(id:id, language:languageCode) else {
        print("Failed to get the movie detail (movieId:\(id))")
        return nil
    }
    return movieDetail
  }
  
  func getPopularMovieList(localeIdentifier: LocaleIdentifier = .English) {
    Task {
      let language = localeIdentifier.rawValue

      if currentLanguage != language {
        movieCardDeck = []
        currentLanguage = language
      }
            
      var movieListResponse: MovieResponse? = nil
      var newMovies: [Movie] = []
      
      // Repeat until movieCardDeck size is big enough
      repeat {
        do {
          movieListResponse = try await APIgetPopularMovieList(page: popularMoviePage, language: language)
          
          // filter favoriteMovies from incoming movies
          let favoriteMovieIds = favoriteMovies.map { $0.id }
          newMovies = movieListResponse?.results.filter { !favoriteMovieIds.contains($0.id) } ?? []
          self.movieCardDeck.append(contentsOf: newMovies)

          if movieCardDeck.count > 2 {
            DispatchQueue.main.async {
              self.reloadMovieCardsToShow()
            }
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
        self.getPopularMovieList(localeIdentifier: self.localeIdentifier)
      }
    }
  }
  
  func reloadMovieCardsToShow() {
    // Always show 2 movie cards on the screen
    movieCardDeck.shuffle()
    while self.movieCardsToShow.count < 2 {
      if(self.movieCardDeck.count == 0) { break }
      
      let movieToAdd = self.movieCardDeck.removeFirst()
      
      self.movieCardsToShow.insert(movieToAdd, at: 0)
    }
  }
  
  func addMovieCardToFavorite(_ movie: Movie) {
    // create FavoriteMovie in SwiftData
    createFavoriteMovie(movie)
    
    // Refresh [FavoriteMovie]
    fetchFavoriteMovies()
    
    // Remove the duplicate from CardDeck
    movieCardDeck.removeAll { $0.id == movie.id }
        
    // Refresh movieCardsToShow
    removeTopMovieCardAndReload()
  }
  
  func removeTopMovieCardAndReload() {
    // Refresh movieCardsToShow
    _ = movieCardsToShow.popLast()
    DispatchQueue.main.async {
      self.reloadMovieCardsToShow()
    }
  }
  
  func isTopMovieCard(_ movie: Movie) -> Bool {
    guard let index = movieCardsToShow.firstIndex(where: {$0.id == movie.id}) else {
      return false
    }
    return index == (movieCardsToShow.count - 1)
  }
}
