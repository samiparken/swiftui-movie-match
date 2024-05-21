import SwiftUI

struct DetailCardView: View, Identifiable {
  let id = UUID() //for Identifiable
  var movieDetail: MovieDetail
  @Binding var isClicked: Bool // Use Binding for isClicked
  
  var body: some View {
    AsyncImage(
      url: URL(string: movieDetail.posterPath!.toImageUrl())) { phase in
        switch phase {
        case .empty:
          // Placeholder view while loading
          Text("Loading...")
        case .success(let image):
          // Success: Show the image
          image
            .resizable()
            .cornerRadius(24)
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: .infinity)
            .overlay(
              !isClicked ? nil :
                ZStack {
                  
                  // dark layer
                  Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                    .cornerRadius(24)
                  
                  // Scroll for movie detail
                  ScrollView(.vertical, showsIndicators: true){
                    VStack(alignment: .center, spacing: 12) {
                      
                      // title
                      Text(movieDetail.title.uppercased()) //title
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .shadow(radius: 1)
                        .padding(.top, 40)
                        .overlay(
                          Rectangle()
                            .fill(Color.white)
                            .frame(height: 1),
                          alignment: .bottom
                        )
                        .padding(.horizontal, 18)
                        .padding(.bottom, 10)
                      
                      // description
                      Text(movieDetail.overview) // overview
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(minWidth: 85, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                      
                      Spacer()
                    }
                    .frame(minWidth: 280) //VStack frame
                    .padding(.bottom, 50) //VStack padding
                  }
                }
            )
            .animation(.easeInOut(duration: 0.3), value: isClicked)
            .onTapGesture {
              isClicked.toggle()
            }
        case .failure:
          // Error: Show placeholder or error message
          Text("Failed to load image")
        @unknown default:
          // Placeholder view while loading
          Text("Placeholder")
        }
      }
      .padding(.horizontal)
  }
}

struct Detail_Previews: PreviewProvider {
  static var previews: some View {
    let sampleMovie = MovieDetail(
        adult: false,
        backdropPath: "/ySgY4jBvZ6qchrxKnBg4M8tZp8V.jpg",
        belongsToCollection: nil, // Assuming no collection for this sample
        budget: 28000000,
        genres: [
            Genre(id: 27, name: "Horror"),
            Genre(id: 53, name: "Thriller")
        ],
        homepage: "https://www.abigailmovie.com",
        id: 1111873,
        imdbID: "tt27489557",
        originCountry: ["US"],
        originalLanguage: "en",
        originalTitle: "Abigail",
        overview: "A group of criminals kidnaps a teenage ballet dancer, the daughter of a notorious gang leader, in order to obtain a ransom of $50 million, but over time, they discover that she is not just an ordinary girl. After the kidnappers begin to diminish, one by one, they discover, to their increasing horror, that they are locked inside with an unusual girl.",
        popularity: 1077.607,
        posterPath: "/7qxG0zyt29BI0IzFDfsps62kbQi.jpg",
        productionCompanies: [
            ProductionCompany(id: 130448, logoPath: "/yHWTTGKbOGZKUd1cp6l3uLyDeiv.png", name: "Project X Entertainment", originCountry: "US"),
            ProductionCompany(id: 126588, logoPath: "/cNhOITS96oOV7SCgUHxvZlWRecx.png", name: "Radio Silence", originCountry: "US"),
            ProductionCompany(id: 33, logoPath: "/8lvHyhjr8oUKOOy2dKXoALWKdp0.png", name: "Universal Pictures", originCountry: "US"),
            ProductionCompany(id: 19367, logoPath: nil, name: "Vinson Films", originCountry: "US")
        ],
        productionCountries: [
            ProductionCountry(iso3166_1: "US", name: "United States of America")
        ],
        releaseDate: "2024-04-18",
        revenue: 37546000,
        runtime: 109,
        spokenLanguages: [
            SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")
        ],
        status: "Released",
        tagline: "Children can be such monsters.",
        title: "Abigail",
        video: false,
        voteAverage: 6.884,
        voteCount: 447
    )
    
    @State var isClicked: Bool = true
    
    DetailCardView(movieDetail: sampleMovie, isClicked: $isClicked)
      .previewLayout(.fixed(width: 375, height: 700))
  }
}
