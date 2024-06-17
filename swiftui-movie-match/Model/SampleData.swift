import Foundation

struct SampleData {
  
  static var favoriteMovie: FavoriteMovie {
    return FavoriteMovie(
      id: 823464,
      posterPath: "/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
      releaseDate: "2024-03-27",
      title: "Godzilla x Kong: The New Empire",
      originalTitle: "Godzilla x Kong: The New Empire",
      overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
      voteAverage: 7.222,
      savedAt: Date(),
      language: "en"
    )
  }
  
  static var movieDetail: MovieDetail {
    return MovieDetail(
      adult: false,
      backdropPath: "/ySgY4jBvZ6qchrxKnBg4M8tZp8V.jpg",
      belongsToCollection: nil, // Assuming no collection for this sample
      budget: 28000000,
      genres: [
        Genre(id: 27, name: "Horror"),
        Genre(id: 53, name: "Thriller")
      ],
      homepage: "https://www.abigailmovie.com",
      id: 1111873,
      imdbID: "tt27489557",
      originCountry: ["US"],
      originalLanguage: "en",
      originalTitle: "Abigail",
      overview: "A group of criminals kidnaps a teenage ballet dancer, the daughter of a notorious gang leader, in order to obtain a ransom of $50 million, but over time, they discover that she is not just an ordinary girl. After the kidnappers begin to diminish, one by one, they discover, to their increasing horror, that they are locked inside with an unusual girl.",
      popularity: 1077.607,
      posterPath: "/7qxG0zyt29BI0IzFDfsps62kbQi.jpg",
      productionCompanies: [
        ProductionCompany(id: 130448, logoPath: "/yHWTTGKbOGZKUd1cp6l3uLyDeiv.png", name: "Project X Entertainment", originCountry: "US"),
        ProductionCompany(id: 126588, logoPath: "/cNhOITS96oOV7SCgUHxvZlWRecx.png", name: "Radio Silence", originCountry: "US"),
        ProductionCompany(id: 33, logoPath: "/8lvHyhjr8oUKOOy2dKXoALWKdp0.png", name: "Universal Pictures", originCountry: "US"),
        ProductionCompany(id: 19367, logoPath: nil, name: "Vinson Films", originCountry: "US")
      ],
      productionCountries: [
        ProductionCountry(iso3166_1: "US", name: "United States of America")
      ],
      releaseDate: "2024-04-18",
      revenue: 37546000,
      runtime: 109,
      spokenLanguages: [
        SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")
      ],
      status: "Released",
      tagline: "Children can be such monsters.",
      title: "Abigail",
      video: false,
      voteAverage: 6.884,
      voteCount: 447
    )
  }

}
