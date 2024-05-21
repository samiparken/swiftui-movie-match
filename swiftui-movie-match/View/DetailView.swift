import SwiftUI
import SwiftData

struct DetailView: View {
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @StateObject var movieManager = MovieManager()
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = true
  @State private var isError = false
  @State private var isClicked = true
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
      Spacer()
      
      VStack {
        if isLoading {
          Text("Loading...")
        } else if isError {
          Text("Failed to load movie detail")
        } else if let movieDetail = movieDetail {
          
          DetailCardView(movieDetail: movieDetail, isClicked: $isClicked)
                    
          Spacer()

          // REMOVE Button
          Button(action:{
            guard let indexToDelete = favoriteMovies.firstIndex(where: {$0.id == movieId}) else {
              self.presentationMode.wrappedValue.dismiss()
              return
            }
            context.delete(favoriteMovies[indexToDelete])
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("Remove".uppercased())
              .modifier(RemoveButtonModifier())
              .padding(.horizontal, 20)
          }
          // CLOSE Button
          Button(action:{
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("Close".uppercased())
              .modifier(CloseButtonModifier())
              .padding(.horizontal, 20)
          }
                  
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
    let movieId = 823464
    DetailView(movieId: movieId)
  }
}
