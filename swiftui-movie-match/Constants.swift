import Foundation

struct K {
  struct UserDefaultsKeys {
    static let region = "region"
    static let language = "language"
  }
    
  struct API {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxY2M4YzU4MGM5YjliMDlmNzY5YmFkMDU0NGFmYjYxYiIsInN1YiI6IjY2NGEyZjRmYzk4ZTAxZDNjZDU0NDVlMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.SFeoEr5hofgVLDSlprxOXPEbCNI4USjpC3y7ncLfq74"
    
    static let imageUrlPrefix_w500 = "https://image.tmdb.org/t/p/w500"
    
    struct Endpoint {
      static let movieListPopular = "/movie/popular"
      static let movieDetail = "/movie/{id}"
    }
  }

  struct Image {
    struct Logo {
      static let primaryLong = "logo_primary_long"
      static let altLong = "logo_alt_long"
      static let altShort = "logo_alt_short"
    }
  }  
}

