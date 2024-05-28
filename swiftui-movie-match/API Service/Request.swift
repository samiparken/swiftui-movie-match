import Foundation

func APIRequest(endpoint: Endpoint) async throws -> (Data, URLResponse) {
  return try await withCheckedThrowingContinuation { continuation in
    let url = URL(string: endpoint.url)!
    var urlRequest = URLRequest(url: url)
    
    // HTTP Method
    urlRequest.httpMethod = endpoint.httpMethod
    
    // Header fields
    endpoint.headers?.forEach { header in
      urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
    }
    
    // Body fields
    if let encoded = endpoint.body?["encoded"], encoded as? Bool == true {
      urlRequest.httpBody = endpoint.encodedBody
    } else {
      urlRequest.httpBody = endpoint.body?.queryString.data(using: .utf8)
    }
    
    urlRequest.timeoutInterval = 10
    
    print("\n")
    print("ENDPOINT: \(endpoint)")
    print("urlRequest: \(urlRequest)")
    if let headers = endpoint.headers {
      print("headers: \(headers)")
    }
    if let body = endpoint.body {
      print("body: \(body)")
      print("body.queryString: \(body.queryString)")
    }
    if let encodedBody = endpoint.encodedBody {
      print("body.encodedJson: \(encodedBody)")
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        continuation.resume(throwing: error)
      } else if let data = data, let response = response {
        continuation.resume(returning: (data, response))
      } else {
        continuation.resume(throwing: URLError(.badServerResponse))
      }
    }
    task.resume()
  }
}
