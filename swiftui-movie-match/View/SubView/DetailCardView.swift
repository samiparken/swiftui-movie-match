import SwiftUI

struct DetailCardView: View, Identifiable {
  let id = UUID() //for Identifiable
  let movieDetail: MovieDetail
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
                        .modifier(TextTitleModifier())
                        .padding(.top, 40)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 10)
                      
                      // Rated
                      HStack {
                        Text("rate-label-string")
                          .modifier(TextLabelModifier())

                        Text(String(movieDetail.voteAverage.rounded(toPlaces: 1))+" / 10")
                          .modifier(TextContentModifier())

                        Spacer()
                      }
                      .padding(.horizontal, 24)
                      .padding(.bottom, -4)
                      
                      // Runtime
                      if let runtime = movieDetail.runtime {
                        HStack {
                          Text("runtime-label-string")
                            .modifier(TextLabelModifier())

                          Text(String(runtime) + " min")
                            .modifier(TextContentModifier())
                          
                          Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, -4)
                      }
                                            
                      // Release date
                      HStack {
                        Text("released-label-string")
                          .modifier(TextLabelModifier())

                        Text(movieDetail.releaseDate)
                          .modifier(TextContentModifier())
                        
                        Spacer()
                      }
                      .padding(.horizontal, 24)
                                          
                      // Genres
                      Text(movieDetail.genres.map{$0.name}.joined(separator: ", "))
                        .foregroundColor(Color.white)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(minWidth: 85, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                      
                      // Description
                      Text(movieDetail.overview)
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
      .padding(.horizontal)
  }
}

struct Detail_Previews: PreviewProvider {
  static var previews: some View {
    @State var isClicked: Bool = true
    DetailCardView(
      movieDetail: SampleData.movieDetail,
      isClicked: $isClicked)
  }
}
