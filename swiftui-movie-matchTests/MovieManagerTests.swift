import XCTest
@testable import swiftui_movie_match

final class MovieManagerTests: XCTestCase {
  var movieManager: MovieManager!
  
  override func setUp() {
    super.setUp()
    movieManager = MovieManager()
  }
  
  override func tearDown() {
    movieManager = nil
    super.tearDown()
  }
  
  func testIsTopMovieCard() {
    // Given
    let movie1 = Movie(
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
    
    let movie2 = Movie(
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
    
    // When
    movieManager.movieCardsToShow = [movie1, movie2]
    
    // Then
    XCTAssertTrue(movieManager.isTopMovieCard(movie2))
    XCTAssertFalse(movieManager.isTopMovieCard(movie1))
  }
}
