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
  private var movieManager = MovieManager()
  @State var showMovieDetailView: Bool = false
  @State private var isClicked: [Int: Bool] = [:]
  let vstackColumnSet = [ GridItem(.flexible()), GridItem(.flexible()) ]
    
  //MARK: - INIT
  init(navStack: Binding<[NavRoute]>) {
    self._navStack = navStack
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
              movie: movie,
              navStack: $navStack
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
    FavoriteView(navStack: .constant([]))
      .modelContainer(for: FavoriteMovie.self, inMemory: true)
  }
}
