import Foundation

protocol Endpoint {
  var httpMethod: String { get }
  var path: String { get }
  var headers: [String: Any]? { get }
  var body: [String: Any]? { get }
  var encodedBody: Data? { get }
  var params: [String: Any]? { get }
}

extension Endpoint {
  // a default extension that creates the full URL
  var url: String {
    switch httpMethod {
    case "GET":
      if let params = params, !params.isEmpty {
        return K.API.baseUrl + path + "?" + params.queryString
      } else {
        return K.API.baseUrl + path
      }
    case "POST":
      return K.API.baseUrl + path
    default:
      return K.API.baseUrl
    }
  }
}

enum EndpointCase: Endpoint {
  case movieListPopular(language: String, page: Int, region: String)
  case movieDetail(id: Int)
  
  var httpMethod: String {
    switch self {
      //case .login .resetPassword, .postProtocol:
      //  return "POST"
    default:
      return "GET"
    }
  }
  
  var path: String {
    switch self {
    case .movieListPopular:
      return K.API.Endpoint.movieListPopular
    case .movieDetail(let id):
      return K.API.Endpoint.movieDetail.replacingOccurrences(of: "{id}", with: "\(id)")
    }
  }
  
  var headers: [String: Any]? {
    let token: String = K.API.bearerToken
    switch self {
    default:
      return ["accept": "application/json",
              "Authorization": "Bearer " + token]
    }
  }
  
  var body: [String : Any]? {
    switch self {
      //    case .login(let email, let password):
      //      return ["grant_type": "password",
      //              "username": email,
      //              "password": password]
      //        case .resetPassword(let email):
      //            return ["email": email]
      //        case .postProtocol:
      //            return ["encoded": true]
    default:
      return [:]
    }
  }
  
  var encodedBody: Data? {
    switch self {
      //        case .postProtocol(let jsonData):
      //            return jsonData
    default:
      return Data()
    }
  }
  
  var params: [String : Any]? {
    switch self {
    case .movieListPopular(let language, let page, let region):
      return ["language" : language, "page" : page, "region" : region]
    default:
      return [:]
    }
  }
}
