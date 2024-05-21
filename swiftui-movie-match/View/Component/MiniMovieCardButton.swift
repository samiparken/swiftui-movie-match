import SwiftUI

struct MiniMovieCardButton: View {
  @Environment(\.colorScheme) var colorScheme

  let id = UUID() //for Identifiable
  var movie: FavoriteMovie
  @Binding var isClicked: Bool
  @State private var uiImage: UIImage? = nil
  @State private var isLoading = true
  
  var body: some View {
    VStack {
      if let uiImage = uiImage {
        Image(uiImage: uiImage)
          .resizable()
          .cornerRadius(24)
          .scaledToFit()
          .frame(minWidth: 0, maxWidth: .infinity)
      } else {
        if isLoading {
          ProgressView() // A spinner or loading indicator
            .frame(minWidth: 0, maxWidth: .infinity)
        } else {
          Image(systemName: "photo")
            .resizable()
            .cornerRadius(24)
            .scaledToFit()
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.gray)
        }
      }
      
      Text(movie.title)
        .foregroundColor(colorScheme == .dark
                         ? .tertiaryColor
                         : .primaryColor)
        .font(.caption)
        .lineLimit(2)
    }
    .onAppear {
      loadImage(from: movie.posterPath!.toImageUrl())
    }
    .onTapGesture {
      isClicked.toggle()
    }
    .sheet(isPresented: $isClicked) {
      DetailView(movieId: movie.id)
    }
  }
  
  private func loadImage(from url: String) {
    guard let imageUrl = URL(string: url) else {
      isLoading = false
      return
    }
    
    DispatchQueue.global().async {
      if let data = try? Data(contentsOf: imageUrl),
         let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.uiImage = image
          self.isLoading = false
        }
      } else {
        DispatchQueue.main.async {
          self.isLoading = false
        }
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
