import SwiftUI
import SwiftData

struct MovieDetailView: View {
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = true
  @State private var isError = false
  @State private var isClicked = false
  let movieId: Int
  
  //MARK: - METHOD
  private func getMovieDetail() async {
    if let movieDetail = await movieManager.getMovieDetail(movieId) {
      self.movieDetail = movieDetail
      isLoading = false
    } else {
      isError = true
      isLoading = false
    }
  }
  
  //MARK: - BODY
  var body: some View {
    VStack {
      HeaderSwipeBar()
      
      VStack {
        if isLoading {
          Text("Loading...")
        } else if isError {
          Text("Failed to load movie detail")
        } else if let movieDetail = movieDetail {
          
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
                        Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
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
            .padding(.horizontal)
                    
          //+TODO: button to remove from favorite
          
          Spacer()
        }
      }
      .task {
        await getMovieDetail()
      }
    }
    
    Spacer()
  }
}


//MARK: - PREVIEW
struct MovieDetailView_Previews: PreviewProvider {
  static var previews: some View {
    let movieId = 1
    
    MovieDetailView(movieId: movieId)
    
  }
}
