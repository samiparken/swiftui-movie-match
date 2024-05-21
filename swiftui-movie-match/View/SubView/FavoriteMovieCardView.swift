import SwiftUI

struct FavoriteMovieCardView: View {
  let id = UUID() //for Identifiable
  var movie: FavoriteMovie
  @Binding var isClicked: Bool // Use Binding for isClicked
  
  var body: some View {
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
            .overlay(
              !isClicked ? nil :
                ZStack {
                  
                  // dark layer
                  Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                    .cornerRadius(24)
                  
                  // Scroll for movie detail
                  ScrollView(.vertical, showsIndicators: true){
                    VStack(alignment: .center, spacing: 12) {
                      
                      // title
                      Text(movie.title.uppercased()) //title
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
                      Text(movie.overview) // overview
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(minWidth: 85)
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
    
    @State var isClicked: Bool = true
    
    FavoriteMovieCardView(movie: sampleFavoriteMovie, isClicked: $isClicked)
  }
}
