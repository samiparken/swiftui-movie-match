import SwiftUI

struct MovieCardView: View, Identifiable {
  let id = UUID() //for Identifiable
  var movie: Movie
  
  var body: some View {
    AsyncImage(
      url: URL(string: movie.posterPath!.toImageUrl())) { phase in
        switch phase {
        case .empty:
          // Placeholder view while loading
          Text("empty")
        case .success(let image):
          // Success: Show the image
          image
            .resizable()
            .cornerRadius(24)
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: .infinity)
            /*
            .overlay(
              VStack(alignment: .center, spacing: 12) {
                Text(movie.title.uppercased()) //title
                  .foregroundColor(Color.white)
                  .font(.largeTitle)
                  .fontWeight(.bold)
                  .shadow(radius: 1)
                  .padding(.horizontal, 18)
                  .padding(.vertical, 4)
                  .overlay(
                    Rectangle()
                      .fill(Color.white)
                      .frame(height: 1),
                    alignment: .bottom
                  )
                Text(movie.overview) // overview
                  .foregroundColor(Color.black)
                  .font(.footnote)
                  .fontWeight(.bold)
                  .frame(minWidth: 85)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 5)
                  .background(
                    Capsule().fill(Color.white)
                  )
              }
                .frame(minWidth: 280) //VStack frame
                .padding(.bottom, 50), //VStack padding
              alignment: .bottom //VStack alignment
            )
             */
        case .failure:
          // Error: Show placeholder or error message
          Text("Failed to load image")
        @unknown default:
          // Placeholder view while loading
          Text("Placeholder")
        }
      }
  }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            id: 1,
            adult: false,
            backdropPath: "/piLUbWQ3pgkma1nCyjHLEoMCSsN.jpg",
            genreIds: [12, 28],
            originalLanguage: "en",
            originalTitle: "Godzilla x Kong: The New Empire",
            overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
            popularity: 10484.676,
            posterPath: "/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
            releaseDate: "2024-03-27",
            title: "Godzilla x Kong: The New Empire",
            video: false,
            voteAverage: 7.222,
            voteCount: 1830
        )
        
        MovieCardView(movie: sampleMovie)
            .previewLayout(.fixed(width: 375, height: 600))
    }
}
