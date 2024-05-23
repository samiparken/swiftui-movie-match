import Foundation

//MARK: - API Calls

func APIgetPopularMovieList(page: Int, language: String) async throws -> MovieResponse {
  let e = EndpointCase.movieListPopular(language: language, page: page, region: "Sweden")
  
  do {
    let (data, response) = try await APIRequest(endpoint: e)
    
    // Check if the response is valid and the status code is in the 200 range
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    
    // Decode the data
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode(MovieResponse.self, from: data)
    return decodedData
    
  } catch {
    print("Error occurred: \(error)")
    throw error
  }
}

func APIgetMovieDetail(id: Int, language: String) async throws -> MovieDetail {
  let e = EndpointCase.movieDetail(id: id, language: language)
  
  do {
    let (data, response) = try await APIRequest(endpoint: e)
    
    // Check if the response is valid and the status code is in the 200 range
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      throw URLError(.badServerResponse)
    }
    
    // Decode the data
    let decoder = JSONDecoder()
    let decodedData = try decoder.decode(MovieDetail.self, from: data)
    return decodedData
    
  } catch {
    print("Error occurred: \(error)")
    throw error
  }
}
