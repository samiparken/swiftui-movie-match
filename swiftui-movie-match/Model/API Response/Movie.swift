import Foundation

struct Movie: Identifiable, Codable {
    let id: Int = 1
    let adult: Bool = false
    let backdropPath: String? = "/piLUbWQ3pgkma1nCyjHLEoMCSsN.jpg"
    let genreIds: [Int] = [12, 28]
    let originalLanguage: String = "en"
    let originalTitle: String = "Godzilla x Kong: The New Empire"
    let overview: String = "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own."
    let popularity: Double = 10484.676
    let posterPath: String? = "/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg"
    let releaseDate: String = "2024-03-27"
    let title: String = "Godzilla x Kong: The New Empire"
    let video: Bool = false
    let voteAverage: Double = 7.222
    let voteCount: Int = 1830
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
