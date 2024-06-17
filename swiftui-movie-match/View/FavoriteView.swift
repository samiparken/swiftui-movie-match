import SwiftUI
import SwiftData

struct FavoriteView: View {
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
    
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query (sort: [SortDescriptor(\FavoriteMovie.savedAt, order: .reverse)]) private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  var movieManager = MovieManager()
  @State var showMovieDetailView: Bool = false
  @State private var isClicked: [Int: Bool] = [:]
  let vstackColumnSet = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
  //MARK: - INIT
  init(navStack: Binding<[NavRoute]>, movieManager: MovieManager) {
    self._navStack = navStack
    self.movieManager = movieManager
  }
  
  //MARK: - BODY
  var body: some View {
    
    VStack {
      HeaderSwipeBar()
      FavoriteHeaderView(numOfFavorites: favoriteMovies.count)

      ScrollView {
        LazyVGrid(columns: vstackColumnSet, spacing: 15) {
          ForEach(favoriteMovies) { movie in
            MiniMovieCardButton(
              navStack: $navStack,
              movie: movie,
              movieManager: movieManager
//              isClicked: Binding(
//                get: { isClicked[movie.id] ?? false },
//                set: { isClicked[movie.id] = $0 }
//              )
            )
          }
        }
        .padding()
      }
      .accessibility(identifier: K.UITests.Identifier.favoriteView)
      
      Spacer()
    }
  }
}

//MARK: - PREVIEW
struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView(navStack: .constant([]), movieManager: MovieManager())
      .modelContainer(for: FavoriteMovie.self, inMemory: true)
  }
}
