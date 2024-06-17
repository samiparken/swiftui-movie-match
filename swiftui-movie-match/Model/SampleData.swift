import Foundation

struct SampleData {
    
  static let favoriteMovie = FavoriteMovie (
    id: 1022789,
    posterPath: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg",
    releaseDate: "2024-06-11",
    title: "Inside Out 2",
    originalTitle: "Inside Out 2",
    overview: "Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone.",
    voteAverage: 7.222,
    savedAt: Date(),
    language: "en"
  )
  
  static let movieDetail = MovieDetail (
    id: 1022789,
    title: "Inside Out 2",
    originalLanguage: "en",
    originalTitle: "Inside Out 2",
    posterPath: "/vpnVM9B6NMmQpWeZvzLvDESb2QY.jpg",
    releaseDate: "2024-06-11",
    genres: [
      Genre(id: 16, name: "Animation"),
      Genre(id: 10751, name: "Family"),
      Genre(id: 18, name: "Drama"),
      Genre(id: 12, name: "Adventure"),
      Genre(id: 35, name: "Comedy")
    ],
    adult: false,
    backdropPath: "/coATv42PoiLqAFKStJiMZs2r6Zb.jpg",
    belongsToCollection: BelongsToCollection(
      id: 1022790,
      name: "Inside Out Collection",
      posterPath: "/Apr19lGxP7gm6y2HQX0kqOXTtqC.jpg",
      backdropPath: "/7U2m2dMSIfHx2gWXKq78Xj1weuH.jpg"
    ),
    budget: 200000000,

    homepage: "https://movies.disney.com/inside-out-2",
    imdbID: "tt22022452",
    originCountry: ["US"],
    overview: "Teenager Riley's mind headquarters is undergoing a sudden demolition to make room for something entirely unexpected: new Emotions! Joy, Sadness, Anger, Fear and Disgust, who’ve long been running a successful operation by all accounts, aren’t sure how to feel when Anxiety shows up. And it looks like she’s not alone.",
    popularity: 6964.86,
    productionCompanies: [
      ProductionCompany(id: 3, logoPath: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png", name: "Pixar", originCountry: "US"),
      ProductionCompany(id: 2, logoPath: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png", name: "Walt Disney Pictures", originCountry: "US")
    ],
    productionCountries: [
      ProductionCountry(iso3166_1: "US", name: "United States of America")
    ],
    revenue: 295800000,
    runtime: 97,
    spokenLanguages: [
      SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")
    ],
    status: "Released",
    tagline: "Make room for new emotions.",
    video: false,
    voteAverage: 7.733,
    voteCount: 193
  )
}
