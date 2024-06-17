import Foundation

struct MovieDetail: Codable {
  let id: Int
  let title: String
  let originalLanguage: String
  let originalTitle: String
  let posterPath: String?
  let releaseDate: String
  let genres: [Genre]

  let adult: Bool
  let backdropPath: String?
  let belongsToCollection: BelongsToCollection?
  let budget: Int
  let homepage: String?
  let imdbID: String?
  let originCountry: [String]
  let overview: String
  let popularity: Double
  let productionCompanies: [ProductionCompany]
  let productionCountries: [ProductionCountry]
  let revenue: Int
  let runtime: Int?
  let spokenLanguages: [SpokenLanguage]
  let status: String
  let tagline: String?
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
    
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case belongsToCollection = "belongs_to_collection"
    case budget
    case genres
    case homepage
    case id
    case imdbID = "imdb_id"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case releaseDate = "release_date"
    case revenue
    case runtime
    case spokenLanguages = "spoken_languages"
    case status
    case tagline
    case title
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}

struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Collection: Codable {
  // Define properties for Collection if available
}

struct Genre: Codable {
  let id: Int
  let name: String
}

struct ProductionCompany: Codable {
  let id: Int
  let logoPath: String?
  let name: String
  let originCountry: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case logoPath = "logo_path"
    case name
    case originCountry = "origin_country"
  }
}

struct ProductionCountry: Codable {
  let iso3166_1: String
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case iso3166_1 = "iso_3166_1"
    case name
  }
}

struct SpokenLanguage: Codable {
  let englishName: String
  let iso639_1: String
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case englishName = "english_name"
    case iso639_1 = "iso_639_1"
    case name
  }
}
