import SwiftUI

struct MiniMovieCardButton: View {
  let id = UUID() //for Identifiable
  var movie: FavoriteMovie
  @Binding var isClicked: Bool
  
  var body: some View {
    Button(action:{
      // ACTION
      print("Favorite Movie Clicked")
      isClicked.toggle()
    }) {
      VStack {
        AsyncImage(
          url: URL(string: movie.posterPath!.toImageUrl())) { phase in
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
            case .failure:
              // Error: Show placeholder or error message
              Text("Failed to load image")
            @unknown default:
              // Placeholder view while loading
              Text("Placeholder")
            }
          }
          .sheet(isPresented: $isClicked) {
            DetailView(movieId: movie.id)
          }
        
        Text(movie.title)
          .font(.footnote)
          .foregroundColor(.primaryColor)
      }
    }
  }
}

struct FavoriteMovieCardView_Previews: PreviewProvider {
  static var previews: some View {
    let sampleFavoriteMovie = FavoriteMovie(
      id: 1,
      posterPath: "/tMefBSflR6PGQLv7WvFPpKLZkyk.jpg",
      releaseDate: "2024-03-27",
      title: "Godzilla x Kong: The New Empire",
      originalTitle: "Godzilla x Kong: The New Empire",
      overview: "Following their explosive showdown, Godzilla and Kong must reunite against a colossal undiscovered threat hidden within our world, challenging their very existence – and our own.",
      voteAverage: 7.222,
      savedAt: Date()
    )
        
    @State var isClicked: Bool = false

    MiniMovieCardButton(movie: sampleFavoriteMovie, isClicked: $isClicked)
  }
}
