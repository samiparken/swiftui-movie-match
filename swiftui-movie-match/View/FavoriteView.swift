import SwiftUI
import SwiftData
import ComposableArchitecture

@Reducer
struct FavoriteFeature {
  //MARK: - State
  @ObservableState
  struct State: Equatable {

  }
  
  //MARK: - Action
  enum Action {
    
  }
  
  //MARK: - Reducer
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      default:
        return .none
      }
    }
  }
}

struct FavoriteView: View {
  //MARK: - TCA store
  @Bindable var store: StoreOf<FavoriteFeature>
  
  //MARK: - Navigation Stack
  @Binding var navStack: [NavRoute]
    
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query (sort: [SortDescriptor(\FavoriteMovie.savedAt, order: .reverse)]) private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  var movieManager = MovieManager()
  let vStackColumnSet = [ GridItem(.flexible()), GridItem(.flexible()) ]

  //MARK: - INIT
  init(store: StoreOf<FavoriteFeature>,
       navStack: Binding<[NavRoute]>,
       movieManager: MovieManager) {
    self.store = store
    self._navStack = navStack
    self.movieManager = movieManager
  }
  
  //MARK: - BODY
  var body: some View {
    
    VStack {
      FavoriteHeaderView(navStack: $navStack,
                         numOfFavorites: favoriteMovies.count)

      ScrollView {
        LazyVGrid(columns: vStackColumnSet, spacing: 15) {
          ForEach(favoriteMovies) { movie in
            MiniMovieCardButton(
              navStack: $navStack,
              movie: movie,
              movieManager: movieManager
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
    FavoriteView(
      store: Store(initialState: FavoriteFeature.State()) {
        FavoriteFeature()
      },
      navStack: .constant([]),
      movieManager: MovieManager())
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
  }
}
