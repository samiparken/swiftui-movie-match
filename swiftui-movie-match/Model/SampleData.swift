import Foundation

struct SampleData {
    
  static let favoriteMovie = FavoriteMovie (
    id: 748783,
    posterPath: "/p6AbOJvMQhBmffd0PIv0u8ghWeY.jpg",
    releaseDate: "2024-04-30",
    title: "The Garfield Movie",
    originalTitle: "The Garfield Movie",
    overview: "Garfield, the world-famous, Monday-hating, lasagna-loving indoor cat, is about to have a wild outdoor adventure! After an unexpected reunion with his long-lost father – scruffy street cat Vic – Garfield and his canine friend Odie are forced from their perfectly pampered life into joining Vic in a hilarious, high-stakes heist.",
    voteAverage: 6.5,
    savedAt: Date(),
    language: "en"
  )
  
  static let movieDetail = MovieDetail (
    id: 748783,
    title: "The Garfield Movie",
    originalLanguage: "en",
    originalTitle: "The Garfield Movie",
    posterPath: "/p6AbOJvMQhBmffd0PIv0u8ghWeY.jpg",
    releaseDate: "2024-04-30",
    genres: [
      Genre(id: 16, name: "Animation"),
      Genre(id: 35, name: "Comedy"),
      Genre(id: 10751, name: "Family"),
      Genre(id: 12, name: "Adventure"),
    ],
    adult: false,
    backdropPath: "/vWzJDjLPmycnQ42IppEjMpIhrhc.jpg",
    belongsToCollection: nil,
    budget: 200000000,

    homepage: "https://www.thegarfield-movie.com/",
    imdbID: "tt22022452",
    originCountry: ["US","GB"],
    overview: "Garfield, the world-famous, Monday-hating, lasagna-loving indoor cat, is about to have a wild outdoor adventure! After an unexpected reunion with his long-lost father – scruffy street cat Vic – Garfield and his canine friend Odie are forced from their perfectly pampered life into joining Vic in a hilarious, high-stakes heist.",
    popularity: 6964.86,
    productionCompanies: [
      ProductionCompany(id: 3, logoPath: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png", name: "Pixar", originCountry: "US"),
      ProductionCompany(id: 2, logoPath: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png", name: "Walt Disney Pictures", originCountry: "US")
    ],
    productionCountries: [
      ProductionCountry(iso3166_1: "US", name: "United States of America")
    ],
    revenue: 217479694,
    runtime: 101,
    spokenLanguages: [
      SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")
    ],
    status: "Released",
    tagline: "Indoor cat. Outdoor adventure.",
    video: false,
    voteAverage: 6.5,
    voteCount: 167
  )
}
