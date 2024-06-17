import Foundation
import SwiftUI
import SwiftData

@Model
class FavoriteMovie {
  @Attribute(.unique) var id: Int
  var savedAt: Date
  var language: String
  var posterPath: String?
  var releaseDate: String
  var title: String
  var originalTitle: String
  var overview: String
  var voteAverage: Double
  
  init(id: Int, posterPath: String? = nil, releaseDate: String, title: String, originalTitle: String, overview: String, voteAverage: Double, savedAt: Date, language: String) {
    self.id = id
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.title = title
    self.originalTitle = originalTitle
    self.overview = overview
    self.voteAverage = voteAverage
    self.savedAt = savedAt
    self.language = language
  }
  
  static var sampleData: FavoriteMovie {
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
}
