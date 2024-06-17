import SwiftUI
import SwiftData
import Observation

struct DetailView: View {
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
  
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentationMode
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = true
  @State private var isError = false
  @State private var isClicked = true
  var movieManager = MovieManager()
  
  let favoriteMovie: FavoriteMovie
  
  //MARK: - METHOD
  private func getMovieDetail() async {
    if let movieDetail = await movieManager.getMovieDetail(
      id: favoriteMovie.id,
      languageCode: favoriteMovie.language ) {
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
          
          //MARK: - DETAILED CARD VIEW
          DetailCardView(movieDetail: movieDetail, isClicked: $isClicked)
          
          Spacer()
          
          //MARK: - REMOVE BUTTON
          Button(action:{
            if let indexToDelete = favoriteMovies.firstIndex(where: {$0.id == favoriteMovie.id}) {
              context.delete(favoriteMovies[indexToDelete])
            }
            movieManager.refreshWidget()
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("remove-string")
              .textCase(.uppercase)
              .modifier(ButtonRemoveModifier())
              .padding(.horizontal, 20)
          }
          
          //MARK: - CLOSE BUTTON
          Button(action:{
            //self.presentationMode.wrappedValue.dismiss()
            navStack.removeLast()
          }) {
            Text("close-string")
              .textCase(.uppercase)
              .modifier(ButtonCloseModifier())
              .accentColor(Color(UIColor(colorScheme == .dark
                                         ? .tertiaryColor
                                         : .primaryColor)))
              .background(
                Capsule().stroke(Color(UIColor(colorScheme == .dark
                                               ? .tertiaryColor
                                               : .primaryColor)), lineWidth: 2)
              )
              .padding(.top, 5)
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
    let sampleFavoriteMovie = SampleData.favoriteMovie
    
    DetailView(navStack: .constant([]),
               favoriteMovie: sampleFavoriteMovie)
  }
}
