import Foundation

//MARK: - API Calls

func APIgetPopularMovieList(page: Int, language: String) async throws -> MovieResponse {
  let e = EndpointCase.movieListPopular(language: language, page: page, region: "Sweden")
  let result = try await makeAPIRequest(endpoint: e, responseType: MovieResponse.self)
  return result
}

func APIgetMovieDetail(id: Int, language: String) async throws -> MovieDetail {
  let e = EndpointCase.movieDetail(id: id, language: language)
  let result = try await makeAPIRequest(endpoint: e, responseType: MovieDetail.self)
  return result
}
