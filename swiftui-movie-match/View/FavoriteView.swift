import SwiftUI
import SwiftData

struct FavoriteView: View {
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  @StateObject var movieManager = MovieManager()
  @State private var isClicked: [Int: Bool] = [:]
  
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    
    VStack {
      HeaderSwipeBar()
      
      ScrollView {
        LazyVGrid(columns: columns, spacing: 15) {
          ForEach(favoriteMovies) { movie in
            FavoriteMovieCardView(
              movie: movie,
              isClicked: Binding(
                get: { isClicked[movie.id] ?? false },
                set: { isClicked[movie.id] = $0 }
              )
            )
          }
        }
        .padding()
      }
      
      Spacer()
    }
  }
}

#Preview {
  FavoriteView()
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}
