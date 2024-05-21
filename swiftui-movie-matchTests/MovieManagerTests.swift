import XCTest
@testable import swiftui_movie_match

final class MovieManagerTests: XCTestCase {
  var movieManager: MovieManager!
  var movie1: Movie!
  var movie2: Movie!
  var movie3: Movie!
  var movie4: Movie!
  var movie5: Movie!
  
  override func setUp() {
    super.setUp()
    movieManager = MovieManager()
    movie1 = Movie(
      id: 1,
      adult: false,
      backdropPath: "backdropPath1",
      genreIds: [1, 2],
      originalLanguage: "en",
      originalTitle: "Original Title 1",
      overview: "Overview 1",
      popularity: 10.0,
      posterPath: "posterPath1",
      releaseDate: "2021-01-01",
      title: "Movie 1",
      video: false,
      voteAverage: 8.0,
      voteCount: 100
    )
    
    movie2 = Movie(
      id: 2,
      adult: false,
      backdropPath: "backdropPath2",
      genreIds: [1, 3],
      originalLanguage: "en",
      originalTitle: "Original Title 2",
      overview: "Overview 2",
      popularity: 20.0,
      posterPath: "posterPath2",
      releaseDate: "2022-01-01",
      title: "Movie 2",
      video: false,
      voteAverage: 9.0,
      voteCount: 200
    )
    
    movie3 = Movie(
      id: 3,
      adult: false,
      backdropPath: "backdropPath3",
      genreIds: [2, 3],
      originalLanguage: "en",
      originalTitle: "Original Title 3",
      overview: "Overview 3",
      popularity: 15.0,
      posterPath: "posterPath3",
      releaseDate: "2023-01-01",
      title: "Movie 3",
      video: false,
      voteAverage: 7.5,
      voteCount: 150
    )
    
    movie4 = Movie(
        id: 4,
        adult: false,
        backdropPath: "backdropPath4",
        genreIds: [2, 4],
        originalLanguage: "en",
        originalTitle: "Original Title 4",
        overview: "Overview 4",
        popularity: 25.0,
        posterPath: "posterPath4",
        releaseDate: "2024-01-01",
        title: "Movie 4",
        video: false,
        voteAverage: 7.8,
        voteCount: 180
    )

    movie5 = Movie(
        id: 5,
        adult: false,
        backdropPath: "backdropPath5",
        genreIds: [3, 5],
        originalLanguage: "en",
        originalTitle: "Original Title 5",
        overview: "Overview 5",
        popularity: 15.0,
        posterPath: "posterPath5",
        releaseDate: "2025-01-01",
        title: "Movie 5",
        video: false,
        voteAverage: 7.0,
        voteCount: 150
    )
  }
  
  override func tearDown() {
    movieManager = nil
    super.tearDown()
  }
  
  func testIsTopMovieCard() {
    // Given
    // movie1, movie2
    
    // When
    movieManager.movieCardsToShow = [movie1, movie2]
    
    // Then
    XCTAssertTrue(movieManager.isTopMovieCard(movie2))
    XCTAssertFalse(movieManager.isTopMovieCard(movie1))
  }
  
  func testRemoveTopMovieCardAndReload() {
    // Given
    movieManager.movieCardsToShow = [movie1, movie2]
    movieManager.movieCardDeck = [movie3,movie4,movie5]

    // When
    _ = movieManager.movieCardsToShow.popLast()
    movieManager.reloadMovieCardsToShow() //async
    
    // Verify that the top movie card is removed
    XCTAssertFalse(movieManager.movieCardsToShow.map{$0.id}.contains(movie2.id), "Top movie card should be removed")
    XCTAssertEqual(movieManager.movieCardsToShow.count, 2, "Always reloaded to 2")
  }
  
  func testWhenMovieCardsToShowIs2ReloadMovieCardsToShow() {
    // Given
    movieManager.movieCardsToShow = [movie1,movie2]
    movieManager.movieCardDeck = [movie3,movie4,movie5]

    // When
    movieManager.reloadMovieCardsToShow() //async
    
    // Verify that the top movie card is removed
    XCTAssertEqual(movieManager.movieCardsToShow.count, 2, "Always reloaded to 2")
  }
}
