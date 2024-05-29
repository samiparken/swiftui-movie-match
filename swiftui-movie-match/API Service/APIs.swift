import Foundation

//MARK: - API Calls

func APIgetPopularMovieList(page: Int, language: String) async throws -> MovieListResponse {
  let e = EndpointCase.movieListPopular(language: language, page: page, region: "Sweden")
  async let result = makeAPIRequest(endpoint: e, responseType: MovieListResponse.self)
  return try await result
}

func APIgetMovieDetail(id: Int, language: String) async throws -> MovieDetail {
  let e = EndpointCase.movieDetail(id: id, language: language)
  async let result = makeAPIRequest(endpoint: e, responseType: MovieDetail.self)
  return try await result
}
