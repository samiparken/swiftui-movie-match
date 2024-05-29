import Foundation

//MARK: - API Calls

func APIgetPopularMovieList(page: Int, language: String) async throws -> MovieResponse {
  let e = EndpointCase.movieListPopular(language: language, page: page, region: "Sweden")
  async let result = makeAPIRequest(endpoint: e, responseType: MovieResponse.self)
  return try await result
}

func APIgetMovieDetail(id: Int, language: String) async throws -> MovieDetail {
  let e = EndpointCase.movieDetail(id: id, language: language)
  async let result = makeAPIRequest(endpoint: e, responseType: MovieDetail.self)
  return try await result
}
