import SwiftUI

struct MainCardView: View, Identifiable {
  //MARK: - PROPERTIES
  let id = UUID() //for Identifiable
  let movie: Movie
  @Binding var isClicked: Bool // Use Binding for isClicked

  //MARK: - BODY
  var body: some View {
    AsyncImage(
      url: URL(string: movie.posterPath!.toImageUrl())) { phase in
        switch phase {
        case .empty:
          // Placeholder view while loading
          VStack {
            Spacer()
            ProgressView() // A spinner or loading indicator
              .frame(minWidth: 20, maxWidth: .infinity)
            Spacer()
          }
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
                        .modifier(TextTitleModifier())
                        .padding(.top, 40)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)
                      
                      // Rated
                      HStack {
                        Text("Rate:")
                          .modifier(TextLabelModifier())

                        Text(String(movie.voteAverage.rounded(toPlaces: 1)) + " / 10")
                          .modifier(TextContentModifier())

                        Spacer()
                      }
                      .padding(.horizontal, 24)
                      .padding(.bottom, -4)
                                                                  
                      // Release date
                      HStack {
                        Text("Released:")
                          .modifier(TextLabelModifier())

                        Text(movie.releaseDate)
                          .modifier(TextContentModifier())

                        Spacer()
                      }
                      .padding(.horizontal, 24)
                          
                      // Description
                      Text(movie.overview)
                        .modifier(TextDescriptionModifier())
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

//MARK: - PREVIEW
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
    
    @State var isClicked: Bool = true
    
    MainCardView(movie: sampleMovie, isClicked: $isClicked)
      .previewLayout(.fixed(width: 375, height: 700))
  }
}
