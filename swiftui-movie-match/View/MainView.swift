import SwiftUI
import SwiftData

struct MainView: View {
  
  // MARK: - SwiftData
  @Environment(\.modelContext) private var context
  @Query private var favoriteMovies: [FavoriteMovie]
  
  //MARK: - PROPERTIES
  @StateObject var movieManager = MovieManager()
  @State var showSettingView: Bool = false
  @State var showFavoriteView: Bool = false
  @State var showMovieDetailView: Bool = false
  
  //MARK: - PRIVATE PROPERTIES
  @GestureState private var dragState = DragState.inactive
  private var dragAreaThreshold: CGFloat = 65.0 // if it's less than 65 points, the card snaps back to its origianl place.
  @State private var lastCardIndex: Int = 1
  @State private var cardRemovalTransition = AnyTransition.trailingBottom
  @State private var isClicked: [Int: Bool] = [:]

  //MARK: - BODY
  var body: some View {
    
    VStack {
      Spacer()

      MainHeaderView(
        movieManager: movieManager,
        showSettingView: $showSettingView)
        .opacity(dragState.isDragging ? 0.0 : 1.0)
        .animation(.default, value: dragState.isDragging)
      
      Spacer()
      
      ZStack{
        if movieManager.movieCardsToShow.isEmpty {
          VStack {
            Spacer()
            Text("Loading...")
            Spacer()
          }
        } else {
          ForEach(movieManager.movieCardsToShow) { movie in
            MainCardView(
              movie: movie,
              isClicked: Binding(
                get: { isClicked[movie.id] ?? false },
                set: { isClicked[movie.id] = $0 }
              )
            )
            //zIndex
              .zIndex(movieManager.isTopMovieCard(movie) ? 1 : 0)
            // Show Symbol
              .overlay(
                ZStack {
                  // X-MARK SYMBOL
                  Image(systemName: "x.circle")
                    .modifier(SymbolModifier())
                    .opacity(self.dragState.translation.width < -self.dragAreaThreshold
                             && movieManager.isTopMovieCard(movie) ? 1.0 : 0.0)
                  // HEART SYMBOL
                  Image(systemName: "heart.circle")
                    .modifier(SymbolModifier())
                    .opacity(self.dragState.translation.width > self.dragAreaThreshold
                             && movieManager.isTopMovieCard(movie) ? 1.0 : 0.0)
                }
              )
            // Drag offset
              .offset(x: movieManager.isTopMovieCard(movie)
                      ? self.dragState.translation.width : 0,
                      y: movieManager.isTopMovieCard(movie)
                      ? self.dragState.translation.height : 0)
            // Scale (before animation)
              .scaleEffect(movieManager.isTopMovieCard(movie)
                           && self.dragState.isDragging ? 0.85 : 1.0)
            //Rotation (before animation)
              .rotationEffect(Angle(degrees:
                                      movieManager.isTopMovieCard(movie)
                                    ? Double(self.dragState.translation.width / 12)
                                    : 0))
            //Animation (spring effect)
              .animation(.interpolatingSpring(stiffness: 120, damping: 120), value: dragState.isDragging)
            //Gesture
              .gesture(LongPressGesture(minimumDuration: 0.01)
                .sequenced(before: DragGesture())
                .updating(self.$dragState,
                          body: { (value, state, transaction) in
                switch value {
                case .first(true):
                  state = .pressing
                case .second(true, let drag):
                  state = .dragging(transition: drag?.translation ?? .zero)
                default:
                  break
                }
              })
               // End of Gesture - Action
                .onEnded({ (value) in
                  guard case .second(true, let drag?) = value else { return }
                  if drag.translation.width < -self.dragAreaThreshold {
                    movieManager.RemoveMovieCard(movie)
                  } else if drag.translation.width > self.dragAreaThreshold {
                    movieManager.AddMovieCardToFavorite(movie)
                  }
                })
              )
          }
        }
      }
      .padding(.horizontal, 13)
      
      Spacer()
      
      MainFooterView(
        showFavoriteView: $showFavoriteView,
        showMovieDetailView: $showMovieDetailView)
        .opacity(dragState.isDragging ? 0.0 : 1.0)
        .animation(.default, value: dragState.isDragging)
      
      Spacer()

    }
    .onAppear {
      // for SwiftData in MovieManager
      movieManager.context = context
      movieManager.fetchFavoriteMovies()
      movieManager.getPopularMovieList()
    }    
  }
}

#Preview {
  MainView()
    .modelContainer(for: FavoriteMovie.self, inMemory: true)
}
