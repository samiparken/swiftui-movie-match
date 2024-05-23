import Foundation
import SwiftUI
import SwiftData

@Model
class FavoriteMovie {
  @Attribute(.unique) var id: Int
  var savedAt: Date
  var posterPath: String?
  var releaseDate: String
  var title: String
  var originalTitle: String
  var overview: String
  var voteAverage: Double
  
  init(id: Int, posterPath: String? = nil, releaseDate: String, title: String, originalTitle: String, overview: String, voteAverage: Double, savedAt: Date) {
    self.id = id
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.title = title
    self.originalTitle = originalTitle
    self.overview = overview
    self.voteAverage = voteAverage
    self.savedAt = savedAt
  }
}
