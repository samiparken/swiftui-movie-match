import SwiftUI
import SwiftData

struct FavoriteView: View {
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query (sort: [SortDescriptor(\FavoriteMovie.savedAt, order: .reverse)]) private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @Binding var showMovieDetailView: Bool
  @StateObject private var movieManager = MovieManager()
  @State private var isClicked: [Int: Bool] = [:]  
  let vstackColumnSet = [ GridItem(.flexible()), GridItem(.flexible()) ]
  
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
              isClicked: Binding(
                get: { isClicked[movie.id] ?? false },
                set: { isClicked[movie.id] = $0 }
              ))
          }
        }
        .padding()
      }
      
      Spacer()
    }
  }
}

//MARK: - PREVIEW
struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    @State var showMovieDetailView: Bool = true
    
    FavoriteView(showMovieDetailView: $showMovieDetailView)
      .modelContainer(for: FavoriteMovie.self, inMemory: true)
  }
}
