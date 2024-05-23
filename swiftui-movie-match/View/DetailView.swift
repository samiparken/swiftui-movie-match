import SwiftUI
import SwiftData

struct DetailView: View {
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @AppStorage(K.AppStorageKey.localeIdentifier) private var localeIdentifier: LocaleIdentifier = .English
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.presentationMode) var presentationMode
  @StateObject var movieManager = MovieManager()
  @State private var movieDetail: MovieDetail?
  @State private var isLoading = true
  @State private var isError = false
  @State private var isClicked = true
  let movieId: Int
  
  //MARK: - METHOD
  private func getMovieDetail() async {
    if let movieDetail = await movieManager.getMovieDetail(id: movieId, localeIdentifier: localeIdentifier ) {
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
            guard let indexToDelete = favoriteMovies.firstIndex(where: {$0.id == movieId}) else {
              self.presentationMode.wrappedValue.dismiss()
              return
            }
            context.delete(favoriteMovies[indexToDelete])
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("remove-string")
              .textCase(.uppercase)
              .modifier(RemoveButtonModifier())
              .padding(.horizontal, 20)
          }
          
          //MARK: - CLOSE BUTTON
          Button(action:{
            self.presentationMode.wrappedValue.dismiss()
          }) {
            Text("close-string")
              .textCase(.uppercase)
              .modifier(CloseButtonModifier())
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
    let movieId = 823464
    DetailView(movieId: movieId)
  }
}
